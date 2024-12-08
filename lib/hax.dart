import 'dart:typed_data';

import 'console.dart';
import 'io.dart';
import 'hax_list.dart';

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
    ExtDataIdPair("00000082", "00000207", Region.jp),
    ExtDataIdPair("0000008f", "00000217", Region.us),
    ExtDataIdPair("00000098", "00000227", Region.eu),
    ExtDataIdPair("000000a1", "00000267", Region.cn),
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

class Hax {
  Hax({required this.model, required minVersion, required maxVersion, required this.fopen, required this.fread}) {
    versions = VersionRange(min: minVersion, max: maxVersion, includeMin: true, includeMax: true);
  }
  Model model;
  late VersionRange versions;
  // since arm9 memory address is 0x08180000 max even on new model, so use int here even though it's not appropriate for 32-bit address
  int fopen;
  int fread;
  static const kCode = "\uC001\uE28F\uFF1C\uE12F\u9911\u480B\u4685\u6569\uA107\u2201\u4B04\u4798\u4668\u4659\uAAC0\u1C17\u4643\u4C02\u47A0\u47B8";
  static const kLegacyCode = "\uFFFF\uFAFF\u9911\u4807\u4685\u6569\uA108\u2201\u4B05\u4798\u4668\u4659\uAAC0\u1C17\u4643\u4C03\u47A0\u47B8\u9000\u080A";
  static const kSdmcB9 = "\u0073\u0064\u006D\u0063\u9000\u080A\u0062\u0039";
  static final extraVersions = VersionRange(max: Version(11, 3, 0), includeMax: true);
  static final list = haxList;
  String get id1 => "$kCode$encodedAddresses$kSdmcB9";
  String get legacyId1 => "$kLegacyCode$encodedAddresses$kSdmcB9";
  String get encodedAddresses => "${encodeAddress(fopen)}${encodeAddress(fread)}";
  static String encodeAddress(int addr) {
    final high = addr >> 16;
    final low = addr & 0xFFFF;
    if (Endian.host == Endian.little) {
      return String.fromCharCodes([low, high]);
    } else { // not tested, will we really ever encounter big-endian system?
      return String.fromCharCodes([((low & 0xFF) << 8) | (low >> 8), ((high & 0xFF) << 8) | (high >> 8)]);
    }
  }
  static String fixHangul(String str) {
    //bool isJamo(int code) => code >= 0x1100 && code <= 0x11FF;
    const choBase = 0x1100;
    bool isCho(int code) => code >= choBase && code <= 0x1112;
    const jungBase = 0x1161;
    bool isJung(int code) => code >= jungBase && code <= 0x1175;
    const jongBase = 0x11A8; // this one start with 1
    bool isJong(int code) => code >= jongBase && code <= 0x11C2;
    final newStr = StringBuffer();
    var syllableCode = 0;
    void appendSyllable() {
      newStr.write(String.fromCharCode(syllableCode + 44032));
      syllableCode = 0;
    }
    for(int i = 0; i < str.length; i++) {
      final code = str.codeUnitAt(i);
      if (isCho(code)) {
        if (syllableCode != 0) {
          appendSyllable();
        }
        syllableCode += (code - choBase) * 588;
      } else if (isJung(code)) {
        syllableCode += (code - jungBase) * 28;
      } else if (isJong(code)) {
        syllableCode += code - jongBase + 1; // this one start with 1
        appendSyllable();
      } else {
        if (syllableCode != 0) {
          appendSyllable();
        }
        newStr.write(str[i]);
      }
    }
    return newStr.toString();
  }
  static Hax? find(Variant variant) => findByMV(variant.model, variant.version);
  static Hax? findByMV(Model model, Version version, [bool extra = false]) {
    if (!extra && extraVersions.allows(version)) return null;
    try {
      return list.firstWhere((hax) => hax.matchByMV(model, version));
    } on StateError {
      return null;
    }
  }
  static bool checkIfHaxId1(String id1, [bool skipFixes = false]) {
    if (isDarwin && !skipFixes) {
      id1 = fixHangul(id1);
    }
    if (id1.length != 32) return false;
    if (!id1.startsWith(kCode) && !id1.startsWith(kLegacyCode)) return false;
    if (!id1.endsWith(kSdmcB9)) return false;
    return true;
  }
  static Hax? findById1(String id1) {
    if (isDarwin) {
      id1 = fixHangul(id1);
    }
    if (!checkIfHaxId1(id1, true)) return null;
    try {
      final m = id1.substring(20, 24);
      return list.firstWhere((hax) => hax.matchByEncodedAddresses(m));
    } on StateError {
      return null;
    }
  }
  Variant get dummyVariant => Variant(model, versions.max!);
  bool match(Variant variant) => matchByMV(variant.model, variant.version);
  bool matchByMV(Model model, Version version) => this.model == model && versions.allows(version);
  bool matchById1(String m, [bool legacy = false]) => id1 == m || (legacy && legacyId1 == m);
  bool matchByEncodedAddresses(String m) => encodedAddresses == m;
}
