import 'package:pub_semver/pub_semver.dart';

export 'package:pub_semver/pub_semver.dart';

enum Model { unknown, oldModel, newModel }

enum Region { jp, us, eu, cn, kr, tw }

Version ver(int major, int minor, [int patch = 0]) {
  final minorMax = versionMajorMinorMap[major];
  if (minorMax == null || minor > minorMax) {
    throw InvalidVersionException();
  }
  if (minor == -1) {
    minor = minorMax;
  }
  return Version(major, minor, patch);
}

class Variant {
  Variant(this.model, this.version);
  final Model model;
  final Version version;

  @override
  bool operator == (covariant Variant other) {
    return model == other.model && version == other.version;
  }

  @override
  int get hashCode => model.hashCode ^ version.hashCode;
}

class InvalidVersionException implements Exception {
}

const versionMajorMinorMap = {
  0: -1, // invalidate all 0.x
  1: 1,
  2: 2,
  3: 1,
  4: 5,
  5: 1,
  6: 4,
  7: 2,
  8: 1,
  9: 9,
  10: 7,
  11: 17
};
