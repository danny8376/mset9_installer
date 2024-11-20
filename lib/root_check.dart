import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:collection/collection.dart' as c;
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show ByteStream, Request, StreamedResponse;
import 'package:http_parser/http_parser.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mset9_installer/talker.dart';
import 'package:webcrypto/webcrypto.dart';

import 'io.dart';
import 'string_utils.dart';
import 'typed_list_util.dart';

part 'root_check.g.dart';

const _cacheExpire = 24 * 3600 * 1000000; // 1 day, probably will never expire practically

final _client = httpClient();

enum CheckStateState { /* ok, */ missing, outdated, unknownOrCorrupted }

class CheckState {
  CheckStateState state;
  bool optional;
  CheckState(this.state, this.optional);
}

Map<int, int> _ensureVariantSelections(Map<int, int>? variantSelections) {
  variantSelections ??= const {};
  if (variantSelections.containsKey(0)) {
    throw const InvalidVariantSelectionException("invalid variantSelections, group 0 can't have variants");
  }
  return variantSelections;
}

Future<Map<String, CheckState>?> sdRootCheck(Directory sdRoot, {Map<int, int>? variantSelections, bool loose = false}) async {
  variantSelections = _ensureVariantSelections(variantSelections);
  final checkList = await RootCheckList.load();
  final missing = <String, CheckState>{};
  for (final MapEntry(key: group, value: variantList) in checkList.groupList.entries) {
    final variantSelection = variantSelections[group];
    Map<String, CheckState>? variantMissing;
    if (variantSelection != null) {
      final variant = variantList[variantSelection];
      if (variant == null) {
        throw InvalidVariantSelectionException("invalid variantSelections, variant $variantSelection doesn't exist in group $group");
      }
      variantMissing = await _checkVariant(sdRoot, variant, loose: loose);
    } else {
      variantMissing = await _checkAllVariants(sdRoot, variantList, loose: loose);
    }
    if (variantMissing != null) {
      missing.addAll(variantMissing);
    }
  }
  return missing.isEmpty ? null : missing;
}

Future<Map<String, CheckState>?> _checkAllVariants(Directory sdRoot, Map<int, Map<String, SDRootFile>> variantList, {bool loose = false}) async {
  final keys = variantList.keys.sorted((a, b) => a.compareTo(b));
  Map<String, CheckState>? firstMissing;
  for (final group in keys) {
    final variantMissing = await _checkVariant(sdRoot, variantList[group]!, loose: loose);
    if (variantMissing == null) {
      return null;
    }
    firstMissing ??= variantMissing;
  }
  return firstMissing;
}

Future<Map<String, CheckState>?> _checkVariant(Directory sdRoot, Map<String, SDRootFile> checks, {bool loose = false}) async {
  final missing = <String, CheckState>{};
  for (final MapEntry(key: path, value: check) in checks.entries) {
    if (check.type == SDRootFileType.archive) {
      continue;
    }
    final optional = loose ?
        !const [SDRootFileType.mset9, SDRootFileType.critical].contains(check.type) :
        check.type == SDRootFileType.recommended;
    final file = await _resolveFile(sdRoot, path, create: false);
    if (file == null) {
      missing[path] = CheckState(CheckStateState.missing, optional);
      continue;
    }
    final stream = await file.openReadAsync();
    final hash = await Hash.sha256.digestStream(stream);
    if (typedDataEquals(check.remoteHash, hash) == true) {
      // latest (remote), check next
      continue;
    }
    if (typedDataEquals(check.hash.first, hash)) {
      // mark outdated when remote hash exists
      if (check.remoteHash != null) {
        missing[path] = CheckState(CheckStateState.outdated, optional);
      }
      // otherwise, this is the latest hash, directly check next
      continue;
    }
    // mark outdated if any remaining hash matches
    if (_checkIfAnyHashMatches(hash, check.hash.sublist(1))) {
      missing[path] = CheckState(CheckStateState.outdated, optional);
      continue;
    }
    // otherwise, unknown or corrupted
    missing[path] = CheckState(CheckStateState.unknownOrCorrupted, optional);
  }
  return missing.isEmpty ? null : missing;
}

bool _checkIfAnyHashMatches(Uint8List hashToCheck, List<Uint8List> hashList) {
  for (final hash in hashList) {
    if (typedDataEquals(hashToCheck, hash)) {
      return true;
    }
  }
  return false;
}

Future<void> downloadSdRootFiles(Directory sdRoot, {List<String>? fileList, Map<int, int>? variantSelections}) async {
  variantSelections = _ensureVariantSelections(variantSelections);
  final checkList = await RootCheckList.load();
  var downloadOrder = <String>[]; // all lowercase
  final downloadList = <String, _SDRootFileDownloadEntry>{}; // all lowercase
  for (final MapEntry(key: group, value: variantList) in checkList.groupList.entries) {
    final variantSelection = variantSelections[group] ?? variantList.keys.sorted((a, b) => a.compareTo(b)).first;
    for (final MapEntry(key: fileName, value: check) in variantList[variantSelection]!.entries) {
      final lowerCasedFileName = fileName.toLowerCase();
      if (fileList == null || fileList.contains(fileName)) {
        downloadList[lowerCasedFileName] = _SDRootFileDownloadEntry(check, fileName);
        downloadOrder.add(lowerCasedFileName);
        var prevFileName = lowerCasedFileName;
        for (final uri in check.src.reversed) {
          if (uri.scheme == "archive") {
            final archive = checkList.checks[uri.host]!;
            downloadList[uri.host] ??= _SDRootFileDownloadEntry(archive, uri.host, {});
            final extractMap = downloadList[uri.host]!.extractMap!;
            extractMap.addEntries(
                archive.extractMap.entries
                    .where((e) => e.key.endsWith("#$group,$variantSelection"))
                    .map((e) => MapEntry(e.key.split("#").first, e.value))
            );
            downloadOrder.insert(downloadOrder.indexOf(prevFileName), uri.host);
            prevFileName = uri.host;
          }
        }
      }
    }
  }
  downloadOrder = downloadOrder.distinct().toList(growable: false);
  //talker.debug(downloadOrder);
  //talker.debug(downloadList);
  for (final downloadIndex in downloadOrder) {
    final downloadEntry = downloadList[downloadIndex]!;
    final _SDRootFileDownloadEntry(:check, :fileName, :extractMap, :done) = downloadEntry;
    if (done) { // should we ignore archive? they shouldn't ever be marked done though.
      continue;
    }
    // all files extracted, skip
    if (extractMap?.values.every((e) => downloadList[e]?.done == true) == true) {
      talker.debug("RootCheck: all files for $fileName are already done, skip.");
      continue;
    }
    for (final uri in check.src) {
      try {
        // TODO: implement streamed decoder properly, while we're probably never going to have really huge zip
        TypedData bytes = switch(uri.scheme) {
          "local" => await rootBundle.load("${uri.host}${uri.path}"),
          "http" || "https" => await _getFileFromHttp(uri),
          // TODO: add github release support
          "github" => throw const _SdRootDownloadSkip(),
          "archive" => throw const _SdRootDownloadSkip(),
          _ => throw UnimplementedError(),
        };
        final input = InputStream(bytes);
        if (uri.hasFragment || check.type == SDRootFileType.archive) {
          final archive = ZipDecoder().decodeBuffer(input);
          for (final archiveFile in archive.files) {
            if (!archiveFile.isFile) {
              continue;
            }
            String? extractTo;
            if (uri.hasFragment && archiveFile.name == uri.fragment) {
              extractTo = fileName;
            } else {
              extractTo = extractMap?[archiveFile.name];
            }
            if (extractTo == null) {
              continue;
            }
            final extractToDownloadEntry = downloadList[extractTo.toLowerCase()];
            if (extractToDownloadEntry == null) {
              throw Exception("What??? entry gone???");
            }
            if (extractToDownloadEntry.done == true) {
              continue;
            }
            final file = await _resolveFile(sdRoot, extractTo, create: true);
            final content = archiveFile.content;
            if (content is! Uint8List) {
              throw const FormatException("archiveFile content is unknown type");
            }
            check.remoteHash = await Hash.sha256.digestBytes(content);
            await file?.writeAsBytes(content);
            extractToDownloadEntry.done = true;
            talker.debug("RootCheck: $fileName : ${archiveFile.name} => $extractTo");
          }
        } else {
          final file = await _resolveFile(sdRoot, fileName, create: true);
          final content = bytes.buffer.asUint8List();
          check.remoteHash = await Hash.sha256.digestBytes(content);
          await file?.writeAsBytes(content);
          downloadEntry.done = true;
          talker.debug("$uri => $fileName");
        }
        break;
      } on _SdRootDownloadSkip {
        continue;
      } catch (e, st) {
        talker.debug("RootCheck: Error getting remote file: $uri", e, st);
        continue;
      }
    }
  }
}

Future<TypedData> _getFileFromHttp(Uri uri) async {
  final res = await uri.get();
  final targetMsMd5 = res.headers["x-ms-blob-content-md5"];
  final targetSha256 = res.headers["x-hash-sha256"];
  final content = await res.stream.toBytes();
  if (targetMsMd5 != null) {
    talker.debug("RootCheck: targetMd5 (base64) of $uri : $targetMsMd5");
    final hash = crypto.md5.convert(content);
    if (base64Encode(hash.bytes) != targetMsMd5) {
      throw const _HTTPDataCorruptedException();
    }
  }
  if (targetSha256 != null) {
    talker.debug("RootCheck: targetSha256 of $uri : $targetSha256");
    final hash = await Hash.sha256.digestBytes(content);
    if (hex.encode(hash) != targetSha256) {
      throw const _HTTPDataCorruptedException();
    }
  }
  return content;
}

Future<File?> _resolveFile(Directory parent, String path, {bool create = false, bool caseInsensitive = true}) async {
  final pathList = path.split("/");
  final fileName = pathList.last;
  for (final dirName in pathList.sublist(0, pathList.length - 1)) {
    final folder = await parent.directory(dirName, create: create, caseInsensitive: caseInsensitive);
    if (!create && folder == null) {
      return null;
    }
    parent = folder!;
  }
  return await parent.file(fileName, create: create, caseInsensitive: caseInsensitive);
}

class _SDRootFileDownloadEntry {
  SDRootFile check;
  String fileName;
  Map<String, String>? extractMap;
  bool done = false;
  _SDRootFileDownloadEntry(this.check, this.fileName, [this.extractMap]);
}

extension _IterableDistinctUtil<T> on Iterable<T> {
  Iterable<T> distinct() sync* {
    final visited = <T>{};
    for (final el in this) {
      if (visited.contains(el)) continue;
      yield el;
      visited.add(el);
    }
  }
}

class _SdRootDownloadSkip implements Exception {
  const _SdRootDownloadSkip();
}

@JsonSerializable()
class RootCheckList {
  @JsonKey(required: true)
  int update;

  @JsonKey(required: true)
  @_UriConverter()
  List<Uri> src;

  @JsonKey(required: true, fromJson: _checksFromJson)
  Map<String, SDRootFile> checks;

  @JsonKey(includeFromJson: false, includeToJson: false)
  late Map<int, Map<int, Map<String, SDRootFile>>> groupList;

  static RootCheckList? _cache;
  static int _cacheTimeline = -1;

  RootCheckList(this.update, this.src, this.checks);

  static Map<String, SDRootFile> _checksFromJson(Map<String, dynamic> json) {
    final map = HashMap<String, SDRootFile>(
        equals: (a, b) => a.equalsIgnoreAsciiCase(b),
        hashCode: (a) => a.toLowerCase().hashCode
    );
    for (final MapEntry(:key, :value) in json.entries) {
      map[key] = SDRootFile.fromJson(value as Map<String, dynamic>);
    }
    return map;
  }

  SDRootFile resolveLink(SDRootFile file) {
    if (file.type != SDRootFileType.link) {
      return file;
    }
    final uri = file.src.first;
    if (uri.scheme != "link") {
      throw const InvalidRootCheckListJsonException();
    }
    final linked = checks["${uri.host}#virtual"];
    if (linked == null) {
      throw const InvalidRootCheckListJsonException();
    }
    return linked;
  }

  factory RootCheckList._fromJson(Map<String, dynamic> json, [Map<String, SDRootFile>? existingChecks]) {
    final list = _$RootCheckListFromJson(json);
    list.checkAndUpdateValues(existingChecks);
    return list;
  }

  void checkAndUpdateValues([Map<String, SDRootFile>? existingChecks]) {
    groupList = {};
    for (final MapEntry(:key, value: oriCheck) in checks.entries) {
      final [fileName, ...splitRest] = key.split("#");
      final check = resolveLink(oriCheck);
      // it seems we don't have direct nullable pattern?
      final groupKey = splitRest.firstOrNull;
      final localOnly = existingChecks?[fileName]?.localOnly ?? check.localOnly;
      // groupList
      if (groupKey != "virtual" && check.type != SDRootFileType.archive) {
        final groupPair = groupKey?.split(",").map((s) => int.parse(s));
        final [group, variant] = (groupPair?.toList(growable: false) ?? const [0, 0]);
        final variantList = (groupList[group] ??= {});
        final checkMap = (variantList[variant] ??= {});
        checkMap[fileName] = check;
      }
      // check.extractMap && localOnly
      for (final uri in check.src) {
        if (localOnly && uri.scheme != "local") {
          throw const InvalidRootCheckListJsonException();
        }
        if (groupKey == "virtual" || uri.scheme != "archive") {
          continue;
        }
        final archive = checks[uri.host] ?? checks["${uri.host}#$groupKey"];
        if (archive == null) {
          throw const InvalidRootCheckListJsonException();
        }
        final extractKey = "${uri.fragment}#${groupKey ?? "0,0"}";
        archive.extractMap[extractKey] = fileName;
        //talker.debug("updateVal: ${uri.host} : ${uri.fragment} => $fileName");
      }
    }
  }

  // get first available (and valid), drop all remaining even they're newer
  Future<void> checkUpdate() async {
    RootCheckList? newData;
    for (final uri in src) {
      try {
        talker.debug("RootCheck: checking remote JSON: $uri");
        final res = await uri.get();
        newData = RootCheckList._fromJson(jsonDecode(await res.stream.bytesToString()), checks);
        if (newData.update < update) {
          return;
        }
        break;
      } catch (e, st) {
        talker.debug("RootCheck: Error getting remote JSON: $uri", e, st);
        continue;
      }
    }
    if (newData == null) {
      return;
    }
    update = newData.update;
    src = newData.src;
    checks = newData.checks;
    groupList = newData.groupList;
  }

  static Future<RootCheckList> load() async {
    if (_cache == null) {
      final json = await rootBundle.loadString("assets/root_check_list.json");
      _cache = RootCheckList._fromJson(jsonDecode(json));
    }
    if (_cacheTimeline < 0 || FlutterTimeline.now - _cacheTimeline > _cacheExpire) {
      _cacheTimeline = FlutterTimeline.now;
      await _cache!.checkUpdate();
    }
    return _cache!;
  }
}

enum SDRootFileType { archive, link, mset9, critical, essential, recommended }

@JsonSerializable()
class SDRootFile {
  @JsonKey(required: true)
  final SDRootFileType type;

  @JsonKey(required: true)
  @_HexConverter()
  final List<Uint8List> hash;

  @JsonKey(required: true)
  @_UriConverter()
  final List<Uri> src;

  @JsonKey()
  final ArchiveInfo? info;

  @JsonKey()
  final bool localOnly;

  @JsonKey(includeFromJson: false, includeToJson: false)
  late Map<String, String> extractMap;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? remoteHash;

  SDRootFile(this.type, this.hash, this.src, [this.info, this.localOnly = false]);

  factory SDRootFile.fromJson(Map<String, dynamic> json) {
    final file = _$SDRootFileFromJson(json);
    file.extractMap = <String, String>{};
    return file;
  }
}

@JsonSerializable()
class ArchiveInfo {
  @JsonKey()
  final int? size;

  @JsonKey()
  @_HexConverter()
  final Uint8List? sha256;

  @JsonKey()
  @_HexConverter()
  final Uint8List? md5;

  @JsonKey()
  @_DateTimeConverter()
  final DateTime? update;

  ArchiveInfo({this.size, this.sha256, this.md5, this.update});

  factory ArchiveInfo.fromJson(Map<String, dynamic> json) => _$ArchiveInfoFromJson(json);
}

class _HexConverter implements JsonConverter<Uint8List, String> {
  const _HexConverter();

  @override
  Uint8List fromJson(String json) => Uint8List.fromList(hex.decode(json));

  @override
  String toJson(Uint8List value) => hex.encode(value.toList(growable: false));
}

class _UriConverter implements JsonConverter<Uri, String> {
  const _UriConverter();

  @override
  Uri fromJson(String json) => Uri.parse(json);

  @override
  String toJson(Uri value) => value.toString();
}

class _DateTimeConverter implements JsonConverter<DateTime, dynamic> {
  const _DateTimeConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    if (json is String) {
      try {
        return DateTime.parse(json);
      } on FormatException { // ignore
      }
      return parseHttpDate(json);
    }
    throw FormatException("Invalid date format", json);
  }

  @override
  int toJson(DateTime value) => value.millisecondsSinceEpoch;
}

extension _UriUtil on Uri {
  Future<StreamedResponse> get() async {
    final req = Request("GET", this)
      ..followRedirects = true;
    final res = await _client.send(req);
    if (res.statusCode < 200 || res.statusCode > 299) {
      throw _HTTPErrorException(res.statusCode, res.reasonPhrase);
    }
    return res;
  }
}

class _HTTPErrorException implements Exception {
  final int code;
  final String? phrase;
  const _HTTPErrorException(this.code, this.phrase);
  @override
  String toString() => "HTTPError($code, $phrase)";
}

class _HTTPDataCorruptedException implements Exception {
  const _HTTPDataCorruptedException();
}

class InvalidVariantSelectionException implements Exception {
  final String message;
  const InvalidVariantSelectionException(this.message);
}

class InvalidRootCheckListJsonException implements Exception {
  const InvalidRootCheckListJsonException();
}
