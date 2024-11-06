import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../string_utils.dart';

export 'dart:io';

bool get isMobile => Platform.isAndroid || Platform.isIOS;
bool get isSupported => true;
bool get showPickN3DS => Platform.isAndroid;

Future<Directory?> pickFolder() async {
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    return await pickFolderDesktop();
  } else if (Platform.isAndroid || Platform.isIOS) {
    return null;
  } else {
    throw UnimplementedError('Unsupported');
  }
}

Future<Directory?> pickFolderDesktop() async {
  final picked = await FilePicker.platform.getDirectoryPath();

  if (picked == null) {
    return null;
  }

  final dir = Directory(picked);
  return dir;
}

class FileSystemUtils {
  static Future<bool> isDirectory(FileSystemEntity e) => FileSystemEntity.isDirectory(e.path);
  static Future<bool> isFile(FileSystemEntity e) => FileSystemEntity.isFile(e.path);
}

extension FileSystemDesktopMobileExtention on FileSystemEntity {
  String get name => p.basename(path);
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
  Future<File?> file(String? name, {bool create = false, bool caseInsensitive = false}) async {
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
  Future<Directory?> directory(String? name, {bool create = false, bool caseInsensitive = false}) async {
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
  Future<FileSystemEntity?> child(String? name, {bool caseInsensitive = false}) async {
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

  Future<Directory> renameInplace(String newName) {
    final dir = p.dirname(path);
    final newPath = p.join(dir, newName);
    return rename(newPath);
  }
  Future<Directory> renameAddSuffix(String suffix) {
    return rename("$path$suffix");
  }
}
