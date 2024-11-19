import 'dart:io';
import 'dart:typed_data';

abstract class ExtendedFileSystemEntity {
  String get name => throw UnimplementedError('Unsupported');

  Future<bool> get isDirectoryImpl => throw UnimplementedError('Unsupported');
  Future<bool> get isFileImpl => throw UnimplementedError('Unsupported');
}

abstract interface class ExtendedDirectory {
  Future<File?> file(String? name, {bool create = false, bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');
  Future<Directory?> directory(String? name, {bool create = false, bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');
  Future<FileSystemEntity?> child(String? name, {bool caseInsensitive = false}) => throw UnimplementedError('Unsupported');

  bool get isRoot => throw UnimplementedError('Unsupported');

  Future<Directory> renameInplace(String newName) => throw UnimplementedError('Unsupported');
  Future<Directory> renameAddSuffix(String suffix) => throw UnimplementedError('Unsupported');
}

abstract interface class ExtendedFile {
  Future<Stream<Uint8List>> openReadAsync([int? start]) => throw UnimplementedError('Unsupported');
}
