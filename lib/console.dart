enum Model { unknown, oldModel, newModel }

class Version {
  Version(this.major, this.minor);
  final int major;
  final int minor;
}

class Variant {
  Variant(this.model, this.version);
  final Model model;
  final Version version;
}

enum Region { us, eu, jp, ch, kr, tw }
