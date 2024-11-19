import 'io.dart';

Future<bool> findJustOneFolder(Directory? parent, {required Future<bool> Function(Directory) rule, void Function(Directory)? success, void Function(int)? fail}) async {
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

Future<bool> findFirstMatchingFolder(Directory? parent, {required Future<bool> Function(Directory) rule, void Function(Directory)? success, void Function(int)? fail}) async {
  if (parent != null) {
    await for (final sub in parent.list()) {
      if (await FileSystemUtils.isDirectory(sub) && await rule(sub as Directory)) {
        success?.call(sub);
        return true;
      }
    }
  }
  fail?.call(0);
  return false;
}
