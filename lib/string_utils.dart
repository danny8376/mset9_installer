import 'package:collection/collection.dart' as c;

extension StringUtils on String {
  bool equalsIgnoreAsciiCase(String b) => c.equalsIgnoreAsciiCase(this, b);
}
