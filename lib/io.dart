import 'io/desktop_mobile.dart' // ignore: unused_import
  if (dart.library.html) 'io/web.dart';

export 'io/desktop_mobile.dart'
  if (dart.library.html) 'io/web.dart';

extension StreamExtension<T> on Stream {
  Future<bool> asyncAny(Future<bool> Function(T) rule) async {
    await for (final entity in this) {
      if (await rule(entity)) return true;
    }
    return false;
  }
}
