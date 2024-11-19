bool get isDesktop => throw UnimplementedError('Unsupported');
bool get isMobile => throw UnimplementedError('Unsupported');
bool get isSupported => throw UnimplementedError('Unsupported');
bool get isLegacyCodeCompatible => throw UnimplementedError('Unsupported');
bool get canAccessParentOfPicked => throw UnimplementedError('Unsupported');
bool get showPickN3DS => throw UnimplementedError('Unsupported');

Future<Directory?> pickFolder() => throw UnimplementedError('Unsupported');
Client httpClient() => throw UnimplementedError('Unsupported');

class FileSystemUtils {
  static Future<bool> isDirectory(FileSystemEntity e) => throw UnimplementedError('Unsupported');
  static Future<bool> isFile(FileSystemEntity e) => throw UnimplementedError('Unsupported');
}

abstract class FileSystemEntity {
  Directory get parent => throw UnimplementedError('Unsupported');
  String get path => throw UnimplementedError('Unsupported');

  String get name => throw UnimplementedError('Unsupported');

  Future<FileSystemEntity> delete({bool recursive = false}) => throw UnimplementedError('Unsupported');
}
abstract interface class Directory implements FileSystemEntity {
  Directory(String path);

  Stream<FileSystemEntity> list() => throw UnimplementedError('Unsupported');

  Future<File?> file(String? name, {bool create = false, bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');
  Future<Directory?> directory(String? name, {bool create = false, bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');
  Future<FileSystemEntity?> child(String? name, {bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');

  Future<Directory> renameInplace(String newName) => throw UnimplementedError('Unsupported');
  Future<Directory> renameAddSuffix(String suffix) => throw UnimplementedError('Unsupported');
}
abstract interface class File implements FileSystemEntity {
  File(String path);

  Future<int> length() => throw UnimplementedError('Unsupported');
  Future<File> writeAsBytes(List<int> data, {bool flush = false}) => throw UnimplementedError('Unsupported');
  Stream<List<int>> openRead([int? start, int? end]) => throw UnimplementedError('Unsupported');
}

class FileSystemException implements Exception {
  String get message => throw UnimplementedError('Unsupported');
  String get path => throw UnimplementedError('Unsupported');
}

class Client {
}
