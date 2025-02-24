import 'dart:async';
import 'dart:html'; // ignore: avoid_web_libraries_in_flutter
import 'dart:typed_data';

import 'package:http/http.dart' show Client;
import 'package:fetch_client/fetch_client.dart';
import 'package:file_system_access_api/file_system_access_api.dart';
import 'package:path/path.dart' as p;

import '../string_utils.dart';

int _chunkSize = 1 * 1024 * 1024;

const bool isDesktop = false;
const bool isMobile = false;
const bool isLinux = false;
Future<bool> get isArc async => false;
bool get isSupported => FileSystemAccess.supported;
const bool isLegacyCodeCompatible = false;
const bool canAccessParentOfPicked = false;
const bool showPickN3DS = false;

Future<Directory?> pickFolder() async {
  if (!FileSystemAccess.supported) return null;

  try {
    final directory = await window.showDirectoryPicker(mode: PermissionMode.readwrite);
    return Directory(directory);
  } on AbortError {
    return null;
  }
}

// some platform might need init (mainly for MethodChannel?)
Future<void> initWatcher() async {}

// > Currently no observer for web, so this is just dummy functions.
// > However, Chrome do have it as optional experimental feature,
// > so might consider implement it in the future.
// The return value is some internal handle for unwatch,
// the actual implementation should handle the check.
// watcher function get called with a list of changed files/folder path,
// null/empty list means the whole disk/volume is removed/reattached.
// empty should be reattached, but no guarantee for null, need to check.
Future<dynamic> watchFolderAndDriveUpdate(Directory dir, Future<void> Function(List<String>?) watcher) async => null;
Future<void> unwatchFolderAndDriveUpdate(dynamic watcherHandle) async {}

Client? _client;

Client httpClient() {
  _client ??= FetchClient(mode: RequestMode.cors);
  return _client!;
}

class FileSystemUtils {
  static Future<bool> isDirectory(FileSystemEntity e) async => e.handle.kind == FileSystemKind.directory;
  static Future<bool> isFile(FileSystemEntity e) async => e.handle.kind == FileSystemKind.file;
}

class FileSystemEntity {
  final FileSystemHandle handle;
  final FileSystemDirectoryHandle? parentHandle;
  late final bool isRoot;

  FileSystemEntity(this.handle, [this.parentHandle]) {
    isRoot = parentHandle == null;
  }

  // if this is file picked directly, will crash, but should be fine for our case
  Directory get parent => parentHandle == null ? this as Directory : Directory(parentHandle!);
  String get name => handle.name;
  String get path => p.join(parentHandle == null ? "" : parent.path, name);

  Future<FileSystemEntity> delete({bool recursive = false}) async {
    await handle.remove(recursive: recursive);
    return this;
  }
  // TODO: maybe? implement exists for web properly
  Future<bool> exists() async => true;
}

class Directory extends FileSystemEntity {
  final FileSystemDirectoryHandle dirHandle;
  Directory(this.dirHandle, [parent]) : super(dirHandle, parent);

  Stream<FileSystemEntity> list() async* {
    await for (FileSystemHandle subHandle in dirHandle.values) {
      switch (subHandle.kind) {
        case FileSystemKind.directory:
          yield Directory(subHandle as FileSystemDirectoryHandle, dirHandle);
          break;
        case FileSystemKind.file:
          yield File(subHandle as FileSystemFileHandle, dirHandle);
          break;
      }
    }
  }

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
    return await action(name, null);
  }
  Future<File?> file(String? name, {bool create = false, bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub is File ? sub : null;
      }
      try {
        return File(await dirHandle.getFileHandle(child!, create: create), dirHandle);
      } on NotFoundError {
        return null;
      } on FileSystemException {
        return null;
      }
    }, caseInsensitive: caseInsensitive);
  }
  Future<Directory?> directory(String? name, {bool create = false, bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub is Directory ? sub : null;
      }
      try {
        return Directory(await dirHandle.getDirectoryHandle(child!, create: create), dirHandle);
      } on NotFoundError {
        return null;
      } on FileSystemException {
        return null;
      }
    }, caseInsensitive: caseInsensitive);
  }
  Future<FileSystemEntity?> child(String? name, {bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub;
      }
      try {
        return File(await dirHandle.getFileHandle(child!), dirHandle);
      } on NotFoundError { // ignore
      } on FileSystemException { // ignore
      }
      try {
        return Directory(await dirHandle.getDirectoryHandle(child!), dirHandle);
      } on NotFoundError { // ignore
      } on FileSystemException { // ignore
      }
      return null;
    }, caseInsensitive: caseInsensitive);
  }

  // yikes, we need native folder rename
  Future<Directory> renameInplace(String newName) async {
    if (parentHandle == null) {
      throw FileSystemException("Can't rename root folder", p.separator);
    }
    final newFolder = await parent.directory(newName, create: true);
    if (newFolder == null) {
      throw FileSystemException("Unable to get/make newFolder", p.join(parent.path, newName));
    }
    await _recursiveDo<Directory>((sub, parentRes) async {
      final newParent = parentRes ?? newFolder;
      if (sub is File) {
        await sub.fileHandle.move(newParent.dirHandle);
        return null;
      } else {
        return await newParent.directory(sub.name, create: true);
      }
    });
    await delete(recursive: true);
    return newFolder;
  }
  _recursiveDo<ReturnType>(Future<ReturnType?> Function(FileSystemEntity, ReturnType?) action, [Directory? folder, ReturnType? parentRes]) async {
    await for (final sub in (folder ?? this).list()) {
      final res = await action(sub, parentRes);
      if (sub is Directory) {
        await _recursiveDo(action, sub, res);
      }
    }
  }
  Future<Directory> renameAddSuffix(String suffix) {
    return renameInplace("$name$suffix");
  }
}

class File extends FileSystemEntity {
  final FileSystemFileHandle fileHandle;
  File(this.fileHandle, [parent]) : super(fileHandle, parent);

  Future<int> length() async => (await fileHandle.getFile()).size;
  Future<File> writeAsBytes(List<int> data, {bool flush = false}) async {
    final stream = await fileHandle.createWritable();
    await stream.writeAsArrayBuffer(Uint8List.fromList(data));
    flush ? await stream.close() : stream.close();
    return this;
  }

  Stream<Uint8List> _openReadAsync([int? start]) async* {
    final file = await fileHandle.getFile();
    final reader = FileReader();
    for (var i = 0; i < file.size; i += _chunkSize) {
      reader.readAsArrayBuffer(file.slice(i, i + _chunkSize));
      await reader.onLoad.first;
      yield reader.result as Uint8List;
    }
  }
  Future<Stream<Uint8List>> openReadAsync([int? start]) async {
    return _openReadAsync(start);
  }
}

class FileSystemException implements Exception {
  final String message;
  final String path;
  const FileSystemException(this.message, this.path);
}
