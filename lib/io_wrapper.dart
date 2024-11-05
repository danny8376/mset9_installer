import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';

Future<Directory?> pickFolder() async {
  final picked = await FilePicker.platform.getDirectoryPath();

  if (picked == null) {
    return null;
  }

  final dir = Directory(picked);
  return dir;
}

extension FileSystemExtention on FileSystemEntity{
  String get name {
    return p.basename(path);
  }
}
