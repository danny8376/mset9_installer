import 'dart:io';

import 'package:mset9_installer/utils.dart';

import 'console.dart';

class ExtDataPair {
  ExtDataPair(this.homeMenu, this.miiMaker, this.region);
  Directory? homeMenu;
  Directory? miiMaker;
  Region region;
}

class ExtDataIdPair {
  ExtDataIdPair(this.homeMenu, this.miiMaker, this.region);
  String homeMenu;
  String miiMaker;
  Region region;
  static final list = [
    ExtDataIdPair("0000008f", "00000217", Region.us),
    ExtDataIdPair("00000098", "00000227", Region.eu),
    ExtDataIdPair("00000082", "00000207", Region.jp),
    ExtDataIdPair("000000a1", "00000267", Region.ch),
    ExtDataIdPair("000000a9", "00000277", Region.kr),
    ExtDataIdPair("000000b1", "00000287", Region.tw),
  ];
  static Future<ExtDataPair?> findDirectory(Directory? folder, {bool partialMatch = false, Region? matchRegion}) async {
    if (folder == null) {
      return null;
    }
    for (final pair in list) {
      final dirPair = await pair.toDirectory(folder, partialMatch: partialMatch);
      if (dirPair != null && (matchRegion == null || matchRegion == dirPair.region)) {
        return dirPair;
      }
    }
    return null;
  }
  Future<ExtDataPair?> toDirectory(Directory? folder, {bool partialMatch = false}) async {
    if (folder == null) {
      return null;
    }
    final dirHomeMenu = await folder.directory(homeMenu, caseInsensitive: true);
    final dirMiiMaker = await folder.directory(miiMaker, caseInsensitive: true);
    if (!partialMatch && (dirHomeMenu == null || dirMiiMaker == null)) {
      return null;
    }
    if (partialMatch && dirHomeMenu == null && dirMiiMaker == null) {
      return null;
    }
    return ExtDataPair(dirHomeMenu, dirMiiMaker, region);
  }
}

enum Stage { pick, setup, variant, inject, trigger, broken, doingWork }

class Hax {
  Hax({required this.model, required this.minVersion, required this.maxVersion, required this.id1});
  String id1;
  Model model;
  Version minVersion;
  Version maxVersion;
  static final list = [
    Hax(
        model: Model.oldModel,
        minVersion: Version(11, 8),
        maxVersion: Version(11, 17),
        id1: "\uFFFF\uFAFF\u9911\u4807\u4685\u6569\uA108\u2201\u4B05\u4798\u4668\u4659\uAAC0\u1C17\u4643\u4C03\u47A0\u47B8\u9000\u080A\uA071\u0805\uCE99\u0804\u0073\u0064\u006D\u0063\u9000\u080A\u0062\u0039"
    ),
    Hax(
        model: Model.newModel,
        minVersion: Version(11, 8),
        maxVersion: Version(11, 17),
        id1: "\uFFFF\uFAFF\u9911\u4807\u4685\u6569\uA108\u2201\u4B05\u4798\u4668\u4659\uAAC0\u1C17\u4643\u4C03\u47A0\u47B8\u9000\u080A\uA071\u0805\uCE5D\u0804\u0073\u0064\u006D\u0063\u9000\u080A\u0062\u0039"
    ),
    Hax(
        model: Model.oldModel,
        minVersion: Version(11, 4),
        maxVersion: Version(11, 7),
        id1: "\uFFFF\uFAFF\u9911\u4807\u4685\u6569\uA108\u2201\u4B05\u4798\u4668\u4659\uAAC0\u1C17\u4643\u4C03\u47A0\u47B8\u9000\u080A\u9E49\u0805\uCC99\u0804\u0073\u0064\u006D\u0063\u9000\u080A\u0062\u0039"
    ),
    Hax(
        model: Model.newModel,
        minVersion: Version(11, 4),
        maxVersion: Version(11, 7),
        id1: "\uFFFF\uFAFF\u9911\u4807\u4685\u6569\uA108\u2201\u4B05\u4798\u4668\u4659\uAAC0\u1C17\u4643\u4C03\u47A0\u47B8\u9000\u080A\u9E45\u0805\uCC81\u0804\u0073\u0064\u006D\u0063\u9000\u080A\u0062\u0039"
    ),
  ];
  static Hax? find(Variant variant) => findByMV(variant.model, variant.version);
  static Hax? findByMV(Model model, Version version) {
    try {
      return list.firstWhere((hax) => hax.matchByMV(model, version));
    } on StateError {
      return null;
    }
  }
  static Hax? findById1(String id1) {
    try {
      return list.firstWhere((hax) => hax.matchById1(id1));
    } on StateError {
      return null;
    }
  }
  Variant get dummyVariant {
    return Variant(model, maxVersion);
  }
  bool match(Variant variant) => matchByMV(variant.model, variant.version);
  bool matchByMV(Model model, Version version) {
    if (this.model != model) {
      return false;
    }
    if (version.major > maxVersion.major || version.major < minVersion.major) {
      return false;
    }
    if (version.major == maxVersion.major && version.minor > maxVersion.minor) {
      return false;
    }
    if (version.major == minVersion.major && version.minor < minVersion.minor) {
      return false;
    }
    return true;
  }
  bool matchById1(String m) => id1 == m;
}
