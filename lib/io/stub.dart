bool get isDesktop => throw UnimplementedError('Unsupported');
bool get isMobile => throw UnimplementedError('Unsupported');
bool get isLinux => throw UnimplementedError('Unsupported');
bool get isDarwin => throw UnimplementedError('Unsupported');
bool get isSupported => throw UnimplementedError('Unsupported');
bool get isLegacyCodeCompatible => throw UnimplementedError('Unsupported');
bool get canAccessParentOfPicked => throw UnimplementedError('Unsupported');
bool get showPickN3DS => throw UnimplementedError('Unsupported');

Future<Directory?> pickFolder() => throw UnimplementedError('Unsupported');
// some platform might need init (mainly for MethodChannel?)
Future<void> initWatcher() => throw UnimplementedError('Unsupported');
// The return value is some internal handle for unwatch,
// the actual implementation should handle the check.
// watcher function get called with a list of changed files/folder path,
// null/empty list means the whole disk/volume is removed/reattached.
// empty should be reattached, but no guarantee for null, need to check.
Future<dynamic> watchFolderAndDriveUpdate(Directory dir, Future<void> Function(List<String>?) watcher) => throw UnimplementedError('Unsupported');
Future<void> unwatchFolderAndDriveUpdate(dynamic watcherHandle) => throw UnimplementedError('Unsupported');
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
  Future<bool> exists() => throw UnimplementedError('Unsupported');
}
abstract interface class Directory implements FileSystemEntity {
  Directory(String path);

  Stream<FileSystemEntity> list() => throw UnimplementedError('Unsupported');

  Future<File?> file(String? name, {bool create = false, bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');
  Future<Directory?> directory(String? name, {bool create = false, bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');
  Future<FileSystemEntity?> child(String? name, {bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');

  bool get isRoot => throw UnimplementedError('Unsupported');

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

class PathNotFoundException extends FileSystemException {
}

class Client {
}

class Process {
  static void run (String program, List<String> args) => throw UnimplementedError('Not supported');
}
