import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../string_utils.dart';
import 'extended_io.dart';
import 'android.dart';

export 'dart:io';

bool get isMobile => Platform.isAndroid || Platform.isIOS;
bool get isSupported => true;
bool get showPickN3DS => Platform.isAndroid;

Future<Directory?> pickFolder() {
  return switch (Platform.operatingSystem) {
    "windows" || "macos" || "linux" => pickFolderDartIO(),
    "android" => pickFolderAndroid(),
    "ios" => pickFolderDartIO(),
    _ => throw UnimplementedError('Unsupported'),
  };
}

Future<Directory?> pickFolderDartIO() async {
  final picked = await FilePicker.platform.getDirectoryPath();

  if (picked == null) {
    return null;
  }

  return Directory(picked);
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
      return null;
    } else {
      return await action(p.join(path, name), null);
    }
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
