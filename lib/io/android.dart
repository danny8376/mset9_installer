import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mset9_installer/io/desktop_mobile.dart';
import 'package:saf_util/saf_util.dart';
import 'package:saf_util/saf_util_platform_interface.dart' show SafDocumentFile;
import 'package:saf_stream/saf_stream.dart';

import 'extended_io.dart';
import '../string_utils.dart';
import '../talker.dart';

final _safUtil = SafUtil();
final _safStream = SafStream();
const _checker = MethodChannel('moe.saru.homebrew.console3ds.mset9_installer/checker');
const _watcher = MethodChannel('moe.saru.homebrew.console3ds.mset9_installer/watcher');
bool _watcherInitialized = false;

Future<bool?> androidCheckIfArc() => _checker.invokeMethod<bool>("checkIfArc");

Future<Directory?> pickFolderAndroid() async {
  final picked = await _safUtil.openDirectory(writePermission: true);
  if (picked == null) {
    return null;
  }

  final doc = await _safUtil.documentFileFromUri(picked, true);
  if (doc == null) {
    return null;
  }

  return _Directory(doc);
}

typedef AndroidWatcherHandle = String;
typedef Watcher = Future<void> Function(List<String>?);

final Map<AndroidWatcherHandle, Watcher> _watcherList = {};

Future<void> initWatcherAndroid() async {
  if (_watcherInitialized) {
    return;
  }
  _watcherInitialized = true;
  _watcher.setMethodCallHandler((call) async {
    switch (call.method) {
      case "watcher":
        if (call.arguments is! Map) {
          talker.error("invalid arguments for watcher, got ${call.arguments.runtimeType}");
          return;
        }
        final of = call.arguments["of"];
        final updates = call.arguments["updates"];
        if (of is! String || updates is! List<String>?) {
          talker.error("invalid arguments for watcher, got of:${of.runtimeType}, updates:${updates.runtimeType}");
          return;
        }
        final watcher = _watcherList[of];
        if (watcher != null) {
          watcher(updates);
        }
        final ori = call.arguments["originalUri"];
        talker.debug(updates);
        talker.debug(ori);
        return;
      default:
        throw UnimplementedError('Unsupported');
    }
  });
}

Future<dynamic> watchFolderAndDriveUpdateAndroid(Directory dir, Watcher watcher) async {
  talker.debug("watch ${dir.path}");
  final uriString = dir.path;
  _watcherList[uriString] = watcher;
  await _watcher.invokeMethod<Map<String, List<String>?>>("watch", { "uri": uriString });
  // for type checking
  final AndroidWatcherHandle handle = uriString;
  return handle;
}

Future<void> unwatchFolderAndDriveUpdateAndroid(dynamic watcherHandle) async {
  if (watcherHandle is! AndroidWatcherHandle) {
    return;
  }
  talker.debug("unwatch $watcherHandle");
  await _watcher.invokeMethod<Map<String, List<String>?>>("unwatch", { "uri": watcherHandle });
  _watcherList.remove(watcherHandle);
}

abstract class _FileSystemEntity extends FileSystemEntity implements ExtendedFileSystemEntity {
  @override
  Future<bool> exists() => throw UnimplementedError();

  @override
  bool existsSync() => throw UnimplementedError();

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) async {
    await _safUtil.delete(path, await isDirectoryImpl);
    return this;
  }
}

class _Directory extends _FileSystemEntity implements Directory, ExtendedDirectory {
  final SafDocumentFile _doc;
  final Directory? _parent;
  Uri? _uri;

  @override
  late final bool isRoot;

  _Directory(this._doc, [this._parent]) {
    isRoot = _parent == null;
  }

  @override
  Directory get absolute => throw UnimplementedError();

  @override
  String get name => _doc.name;

  @override
  String get path => _doc.uri;

  @override
  Uri get uri => _uri ??= Uri.parse(_doc.uri);

  @override
  Directory get parent => _parent ?? this;

  @override
  Future<bool> get isDirectoryImpl async => true;

  @override
  Future<bool> get isFileImpl async => false;

  @override
  Future<Directory> create({bool recursive = false}) => throw UnimplementedError();

  @override
  void createSync({bool recursive = false}) => throw UnimplementedError();

  @override
  Future<Directory> createTemp([String? prefix]) => throw UnimplementedError();

  @override
  Directory createTempSync([String? prefix]) => throw UnimplementedError();

  @override
  Future<bool> exists() => _safUtil.exists(path, true);

  @override
  Stream<_FileSystemEntity> list({bool recursive = false, bool followLinks = true}) async* {
    for (final sub in await _safUtil.list(path)) {
      yield sub.isDir ? _Directory(sub, this) : _File(sub, this);
    }
  }

  @override
  List<FileSystemEntity> listSync({bool recursive = false, bool followLinks = true}) => throw UnimplementedError();

  @override
  Future<Directory> rename(String newPath) => throw UnimplementedError();

  @override
  Directory renameSync(String newPath) => throw UnimplementedError();

  Future<ReturnType?> _childImpl<ReturnType>(String? name, Future<ReturnType?> Function(String?, _FileSystemEntity?) action, {bool caseInsensitive = false}) async {
    if (name == null) {
      return null;
    }
    if (caseInsensitive) {
      await for (final sub in list()) {
        if (name.equalsIgnoreAsciiCase(sub.name)) {
          return await action(null, sub);
        }
      }
    }
    return await action(name, null);
  }

  @override
  Future<File?> file(String? name, {bool create = false, bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub is _File ? sub : null;
      }
      final doc = await _safUtil.child(path, [child!]);
      if (doc != null) {
        if (doc.isDir) {
          throw FileSystemException("not file", doc.uri);
        } else {
          return _File(doc, this);
        }
      } else if (create) {
        return _File.newFile(child, this);
      } else {
        return null;
      }
    }, caseInsensitive: caseInsensitive);
  }

  @override
  Future<Directory?> directory(String? name, {bool create = false, bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub is _Directory ? sub : null;
      }
      final doc = await _safUtil.child(path, [child!]);
      if (doc != null) {
        if (doc.isDir) {
          return _Directory(doc, this);
        } else {
          throw FileSystemException("not folder", doc.uri);
        }
      } else if (create) {
        return _Directory(await _safUtil.mkdirp(path, [child]), this);
      } else {
        return null;
      }
    }, caseInsensitive: caseInsensitive);
  }

  @override
  Future<FileSystemEntity?> child(String? name, {bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub;
      }
      final doc = await _safUtil.child(path, [child!]);
      if (doc == null) {
        return null;
      } else {
        return doc.isDir ? _Directory(doc, this) : _File(doc, this);
      }
    }, caseInsensitive: caseInsensitive);
  }

  @override
  Future<Directory> renameInplace(String newName) async {
    try {
      return _Directory(await _safUtil.rename(path, true, newName));
    } on PlatformException {
      // special handle thanks to ChromeOS shitty android implementation
      if (await androidCheckIfArc() == true) {
        final child = await _safUtil.child(parent.path, [newName]);
        if (child != null) {
          return _Directory(child);
        }
      }
      rethrow;
    }
  }

  @override
  Future<Directory> renameAddSuffix(String suffix) => renameInplace("$name$suffix");
}

class _File extends _FileSystemEntity implements File, ExtendedFile {
  late SafDocumentFile? _doc; // ignore: prefer_final_fields
  late String? _name; // only exists when this is new file that's not created yet
  final Directory? _parent;

  _File(this._doc, [this._parent]);
  _File.newFile(this._name, [this._parent]) : _doc = null;

  @override
  File get absolute => throw UnimplementedError();

  @override
  String get name => _doc?.name ?? _name!;

  String get _genUri => "${parent.path}/${Uri.encodeComponent(_name!)}";

  @override
  String get path => _doc?.uri ?? _genUri;

  @override
  Directory get parent {
    if (_parent == null) {
      throw FileSystemException("root file", path);
    }
    return _parent!;
  }

  @override
  Future<bool> get isDirectoryImpl async => false;

  @override
  Future<bool> get isFileImpl async => true;

  @override
  Future<File> copy(String newPath) => throw UnimplementedError();

  @override
  File copySync(String newPath) => throw UnimplementedError();

  @override
  Future<File> create({bool recursive = false, bool exclusive = false}) => throw UnimplementedError();

  @override
  void createSync({bool recursive = false, bool exclusive = false}) => throw UnimplementedError();

  @override
  Future<bool> exists() => _safUtil.exists(path, false);

  @override
  Future<DateTime> lastAccessed() => throw UnimplementedError();

  @override
  DateTime lastAccessedSync() => throw UnimplementedError();

  @override
  Future<DateTime> lastModified() => throw UnimplementedError();

  @override
  DateTime lastModifiedSync() => throw UnimplementedError();

  @override
  Future<int> length() async => _doc?.length ?? 0; 

  @override
  int lengthSync() => throw UnimplementedError();

  @override
  Future<RandomAccessFile> open({FileMode mode = FileMode.read}) => throw UnimplementedError();

  @override
  Stream<List<int>> openRead([int? start, int? end]) => throw UnimplementedError();

  @override
  RandomAccessFile openSync({FileMode mode = FileMode.read}) => throw UnimplementedError();

  @override
  IOSink openWrite({FileMode mode = FileMode.write, Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  Future<Uint8List> readAsBytes() => throw UnimplementedError();

  @override
  Uint8List readAsBytesSync() => throw UnimplementedError();

  @override
  Future<List<String>> readAsLines({Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  List<String> readAsLinesSync({Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  Future<String> readAsString({Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  String readAsStringSync({Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  Future<File> rename(String newPath) => throw UnimplementedError();

  @override
  File renameSync(String newPath) => throw UnimplementedError();

  @override
  Future setLastAccessed(DateTime time) => throw UnimplementedError();

  @override
  void setLastAccessedSync(DateTime time) => throw UnimplementedError();

  @override
  Future setLastModified(DateTime time) => throw UnimplementedError();

  @override
  void setLastModifiedSync(DateTime time) => throw UnimplementedError();

  @override
  Future<File> writeAsBytes(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) async {
    if (_parent == null) {
      throw FileSystemException("saf_stream doesn't support write to directly picked file", path);
    }
    await _safStream.writeFileBytes(_parent!.path, name, "application/octet-stream", Uint8List.fromList(bytes));
    return this;
  }

  @override
  void writeAsBytesSync(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) => throw UnimplementedError();

  @override
  Future<File> writeAsString(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) => throw UnimplementedError();

  @override
  void writeAsStringSync(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) => throw UnimplementedError();

  @override
  Future<Stream<Uint8List>> openReadAsync([int? start]) => _safStream.readFileStream(path, start: start);
}
