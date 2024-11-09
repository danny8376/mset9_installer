import 'package:pub_semver/pub_semver.dart';

enum Model { unknown, oldModel, newModel }

class Variant {
  Variant(this.model, this.version);
  final Model model;
  final Version version;
}

enum Region { jp, us, eu, cn, kr, tw }
