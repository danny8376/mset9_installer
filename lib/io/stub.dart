Future<Directory?> pickFolder() => throw UnimplementedError('Unsupported');
bool get isMobile => throw UnimplementedError('Unsupported');

class FileSystemUtils {
  static Future<bool> isDirectory(FileSystemEntity e) => throw UnimplementedError('Unsupported');
  static Future<bool> isFile(FileSystemEntity e) => throw UnimplementedError('Unsupported');
}

class FileSystemEntity {
  Directory get parent => throw UnimplementedError('Unsupported');
  String get name => throw UnimplementedError('Unsupported');
  String get path => throw UnimplementedError('Unsupported');

  delete({bool recursive = false}) => throw UnimplementedError('Unsupported');
}
class Directory extends FileSystemEntity {
  Stream<FileSystemEntity> list() => throw UnimplementedError('Unsupported');

  Future<File?> file(String? name, {bool create = false, bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');
  Future<Directory?> directory(String? name, {bool create = false, bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');
  Future<FileSystemEntity?> child(String? name, {bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');

  Future<Directory> renameInplace(String newName) => throw UnimplementedError('Unsupported');
  Future<Directory> renameAddSuffix(String suffix) => throw UnimplementedError('Unsupported');
}
class File extends FileSystemEntity {
  Future<int> length() => throw UnimplementedError('Unsupported');
  Future<File> writeAsBytes(List<int> data, {bool flush = false}) => throw UnimplementedError('Unsupported');
}

class FileSystemException implements Exception {
  String get message => throw UnimplementedError('Unsupported');
  String get path => throw UnimplementedError('Unsupported');
}
