import 'dart:io';
import 'package:collection/collection.dart' as c;
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

final logger = Logger();

Future<bool> findJustOneFolder(Directory? parent, {required bool Function(Directory) rule, Function(Directory)? success, Function(int)? fail}) {
  return findJustOneFolderAsync(parent, rule: (d) async => rule(d), success: success, fail: fail);
}
Future<bool> findJustOneFolderAsync(Directory? parent, {required Future<bool> Function(Directory) rule, Function(Directory)? success, Function(int)? fail}) async {
  var count = 0;
  Directory? candidate;
  if (parent != null) {
    await for (final sub in parent.list()) {
      if (await FileSystemEntity.isDirectory(sub.path) && await rule(sub as Directory)) {
        candidate = sub;
        count++;
      }
    }
  }
  if (count == 1) {
    success?.call(candidate!);
    return true;
  } else {
    fail?.call(count);
    return false;
  }
}

Future<FileSystemEntity?> findFileIgnoreCase(Directory? parent, String name) async {
  if (parent == null) {
    return null;
  }
  await for (final sub in parent.list()) {
    if (name.equalsIgnoreAsciiCase(p.basename(sub.path))) {
      return sub;
    }
  }
  return null;
}

extension StringUtils on String {
  bool equalsIgnoreAsciiCase(String b) => c.equalsIgnoreAsciiCase(this, b);
}

extension DirectoryUtils on Directory {
  Future<ReturnType?> _childImpl<ReturnType>(String? name, Future<ReturnType?> Function(String?, FileSystemEntity?) action, {bool caseInsensitive = false}) async {
    if (name == null) {
      return null;
    }
    if (caseInsensitive) {
      await for (final sub in list()) {
        if (c.equalsIgnoreAsciiCase(name, p.basename(sub.path))) {
          return await action(null, sub);
        }
      }
      return null;
    } else {
      return await action(p.join(path, name), null);
    }
  }
  Future<File?> file(String? name, {bool skipCheck = false, bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub as File;
      } else if (skipCheck || await FileSystemEntity.isFile(child!)) {
        return File(child!);
      } else {
        return null;
      }
    }, caseInsensitive: caseInsensitive);
  }
  Future<Directory?> directory(String? name, {bool skipCheck = false, bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub as Directory;
      } else if (skipCheck || await FileSystemEntity.isDirectory(child!)) {
        return Directory(child!);
      } else {
        return null;
      }
    }, caseInsensitive: caseInsensitive);
  }
  Future<FileSystemEntity?> child(String? name, {bool caseInsensitive = false}) async {
    return _childImpl(name, (child, sub) async {
      if (sub != null) {
        return sub as Directory;
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
  }}

extension StreamUtils<T> on Stream {
  Future<bool> asyncAny(Future<bool> Function(T) rule) async {
    await for (final entity in this) {
      if (await rule(entity)) return true;
    }
    return false;
  }
}
