import 'string_utils.dart';
import 'io.dart';

Future<bool> findJustOneFolder(Directory? parent, {required bool Function(Directory) rule, Function(Directory)? success, Function(int)? fail}) {
  return findJustOneFolderAsync(parent, rule: (d) async => rule(d), success: success, fail: fail);
}
Future<bool> findJustOneFolderAsync(Directory? parent, {required Future<bool> Function(Directory) rule, Function(Directory)? success, Function(int)? fail}) async {
  var count = 0;
  Directory? candidate;
  if (parent != null) {
    await for (final sub in parent.list()) {
      if (await FileSystemUtils.isDirectory(sub) && await rule(sub as Directory)) {
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
    if (name.equalsIgnoreAsciiCase(sub.name)) {
      return sub;
    }
  }
  return null;
}
