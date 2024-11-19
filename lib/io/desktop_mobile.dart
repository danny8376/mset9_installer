import 'dart:io';
import 'dart:typed_data';

//import 'package:archive/archive.dart';
//import 'package:http/http.dart' show ByteStream, Client;
import 'package:http/http.dart' show Client;
import 'package:cronet_http/cronet_http.dart';
import 'package:cupertino_http/cupertino_http.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/io_client.dart';
import 'package:path/path.dart' as p;

import '../string_utils.dart';
import 'extended_io.dart';
import 'android.dart';

export 'dart:io';
export 'package:archive/archive_io.dart' show ZipDecoder;

//int _httpDiskCacheSize = 10; // MiB

bool get isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;
bool get isMobile => Platform.isAndroid || Platform.isIOS;
const bool isSupported = true;
bool get isLegacyCodeCompatible => !Platform.isMacOS && !Platform.isIOS;
bool get canAccessParentOfPicked => !isMobile;
bool get showPickN3DS => Platform.isAndroid;

Future<Directory?> pickFolder() {
  return switch (Platform.operatingSystem) {
    "windows" || "macos" || "linux" => pickFolderDesktop(),
    "android" => pickFolderAndroid(),
    "ios" => throw UnimplementedError('Unsupported'),
    _ => throw UnimplementedError('Unsupported'),
  };
}

Future<Directory?> pickFolderDesktop() async {
  final picked = await FilePicker.platform.getDirectoryPath();

  if (picked == null) {
    return null;
  }

  return Directory(picked);
}

Client? _client;

Client httpClient() {
  _client ??= _httpClient();
  return _client!;
}

Client _httpClient() {
  if (Platform.isAndroid) {
    /*
    final engine = CronetEngine.build(
      cacheMode: CacheMode.disk,
      cacheMaxSize: _httpDiskCacheSize * 1024 * 1024,
    );
    return CronetClient.fromCronetEngine(engine, closeEngine: true);
    // */
    return CronetClient.defaultCronetEngine();
  }
  if (Platform.isIOS || Platform.isMacOS) {
    /*
    final config = URLSessionConfiguration.ephemeralSessionConfiguration()
      ..cache = URLCache.withCapacity(diskCapacity: _httpDiskCacheSize * 1024 * 1024);
    return CupertinoClient.fromSessionConfiguration(config);
    // */
    return CupertinoClient.defaultSessionConfiguration();
  }
  return IOClient();
}

class FileSystemUtils {
  static Future<bool> isDirectory(FileSystemEntity e) =>
      e is ExtendedFileSystemEntity ? (e as ExtendedFileSystemEntity).isDirectoryImpl : FileSystemEntity.isDirectory(e.path);
  static Future<bool> isFile(FileSystemEntity e) =>
      e is ExtendedFileSystemEntity ? (e as ExtendedFileSystemEntity).isFileImpl : FileSystemEntity.isFile(e.path);
}

extension FileSystemDesktopMobileExtention on FileSystemEntity {
  String get name => this is ExtendedFileSystemEntity ? (this as ExtendedFileSystemEntity).name : p.basename(path);
}

extension DirectoryDesktopMobileExtention on Directory {
  Future<ReturnType?> _childImpl<ReturnType>(String? name, Future<ReturnType?> Function(String?, FileSystemEntity?) action, {bool caseInsensitive = false}) async {
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
    return await action(p.join(path, name), null);
  }
  Future<File?> _file(String? name, {bool create = false, bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub is File ? sub : null;
      } else if (await FileSystemEntity.isFile(child!)) {
        return File(child);
      } else if (create) {
        try {
          return await File(child).create();
        } on FileSystemException {
          return null;
        }
      } else {
        return null;
      }
    }, caseInsensitive: caseInsensitive);
  }
  Future<Directory?> _directory(String? name, {bool create = false, bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub is Directory ? sub : null;
      } else if (await FileSystemEntity.isDirectory(child!)) {
        return Directory(child);
      } else if (create) {
        try {
          return await Directory(child).create();
        } on FileSystemException {
          return null;
        }
      } else {
        return null;
      }
    }, caseInsensitive: caseInsensitive);
  }
  Future<FileSystemEntity?> _child(String? name, {bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub;
      } else if (await FileSystemEntity.isFile(child!)) {
        return File(child);
      } else if (await FileSystemEntity.isDirectory(child)) {
        return Directory(child);
      } else {
        return null;
      }
    }, caseInsensitive: caseInsensitive);
  }
  Future<File?> file(String? name, {bool create = false, bool caseInsensitive = false}) =>
      (this is ExtendedDirectory ? (this as ExtendedDirectory).file : _file)(name, create: create, caseInsensitive: caseInsensitive);
  Future<Directory?> directory(String? name, {bool create = false, bool caseInsensitive = false}) =>
      (this is ExtendedDirectory ? (this as ExtendedDirectory).directory : _directory)(name, create: create, caseInsensitive: caseInsensitive);
  Future<FileSystemEntity?> child(String? name, {bool caseInsensitive = false}) =>
      (this is ExtendedDirectory ? (this as ExtendedDirectory).child : _child)(name, caseInsensitive: caseInsensitive);

  Future<Directory> renameInplace(String newName) {
    if (this is ExtendedDirectory) {
      return (this as ExtendedDirectory).renameInplace(newName);
    } else {
      final dir = p.dirname(path);
      final newPath = p.join(dir, newName);
      return rename(newPath);
    }
  }
  Future<Directory> renameAddSuffix(String suffix) =>
      this is ExtendedDirectory ? (this as ExtendedDirectory).renameAddSuffix(suffix) : rename("$path$suffix");
}

extension FileDesktopMobileExtention on File {
  Future<Stream<Uint8List>> _openReadAsync([int? start]) async {
    return openRead(start).cast();
  }

  Future<Stream<Uint8List>> openReadAsync([int? start]) =>
      (this is ExtendedFile ? (this as ExtendedFile).openReadAsync : _openReadAsync)(start);
}

/*
class ByteStreamInputStream extends InputStream {
  ByteStream stream;

  ByteStreamInputStream(this.stream);

  @override
  List<int> get buffer => throw UnimplementedError();
  @override
  set buffer(List<int> buffer) => throw UnimplementedError();

  @override
  int offset;

  @override
  int position;

  @override
  int start;

  @override
  int operator [](int index) => throw UnimplementedError();

  @override
  Future<void> close() => throw UnimplementedError();

  @override
  void closeSync() => throw UnimplementedError();

  @override
  int indexOf(int value, [int offset = 0]) => throw UnimplementedError();

  @override
  bool get isEOS => throw UnimplementedError();

  @override
  int get length => throw UnimplementedError();

  @override
  InputStreamBase peekBytes(int count, [int offset = 0]) => throw UnimplementedError();

  @override
  int readByte() => throw UnimplementedError();

  @override
  InputStreamBase readBytes(int count) => throw UnimplementedError();

  @override
  String readString({int? size, bool utf8 = true}) => throw UnimplementedError();

  @override
  int readUint16() => throw UnimplementedError();

  @override
  int readUint24() => throw UnimplementedError();

  @override
  int readUint32() => throw UnimplementedError();

  @override
  int readUint64() => throw UnimplementedError();

  @override
  void reset() => throw UnimplementedError();

  @override
  void rewind([int length = 1]) => throw UnimplementedError();

  @override
  void skip(int count) => throw UnimplementedError();

  @override
  InputStreamBase subset([int? position, int? length]) => throw UnimplementedError();

  @override
  Uint8List toUint8List([Uint8List? bytes]) => throw UnimplementedError();
}
 */
