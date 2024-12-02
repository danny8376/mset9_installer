// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:code_builder/code_builder.dart'; // ignore: uri_does_not_exist, depend_on_referenced_packages
import 'package:dart_style/dart_style.dart'; // ignore: uri_does_not_exist, depend_on_referenced_packages
import 'package:yaml/yaml.dart'; // ignore: uri_does_not_exist, depend_on_referenced_packages

const repoCacheDir = ".dart_tool/gen_locale_names";

Future<void> cloneOrPull(String owner, String repo) async {
  final repoCache = "$repoCacheDir/$repo";
  if (await Directory(repoCache).exists()) {
    await Process.run("git", ["pull"], workingDirectory: repoCache);
  } else {
    await Process.run("git", ["clone", "https://github.com/$owner/$repo", repoCache]);
  }
}

void main() async {
  /*
  await Future.wait([
    cloneOrPull("umpirsky", "language-list"),
    cloneOrPull("umpirsky", "country-list"),
  ]);
   */
  const langList = "$repoCacheDir/language-list";
  const countryList = "$repoCacheDir/country-list";
  final pubspecFile = File("pubspec.yaml");
  final pubspec = loadYaml(await pubspecFile.readAsString());
  final mainLocale = pubspec["flutter_intl"]["main_locale"] as String;
  final mainLocaleLanguagesFile = File("$langList/data/$mainLocale/language.json");
  final mainLocaleLanguages = jsonDecode(await mainLocaleLanguagesFile.readAsString()) as Map<String, dynamic>;
  final mainLocaleCountriesFile = File("$countryList/data/$mainLocale/country.json");
  final mainLocaleCountries = jsonDecode(await mainLocaleCountriesFile.readAsString()) as Map<String, dynamic>;
  final Map<(String, String?), (String, String?, String, String?)> localeMap = {};
  final l10n = Directory("lib/l10n");
  await for (final arbFile in l10n.list()) {
    if (arbFile is! File) {
      continue;
    }
    late final dynamic arb;
    try {
      arb = jsonDecode(await arbFile.readAsString());
    } catch (_) {
      continue;
    }
    if (arb is! Map<String, dynamic>) {
      print(arb.runtimeType);
      continue;
    }
    final locale = arb["@@locale"];
    if (locale is! String) {
      continue;
    }
    final [lang, ...rest] = locale.split(RegExp(r'[_-]'));
    final country = rest.firstOrNull;
    final localeLanguagesFile = File("$langList/data/${locale.replaceAll("-", "_")}/language.json");
    final localeLanguages = jsonDecode(await localeLanguagesFile.readAsString()) as Map<String, dynamic>;
    final localeCountriesFile = File("$countryList/data/${locale.replaceAll("-", "_")}/country.json");
    final localeCountries = jsonDecode(await localeCountriesFile.readAsString()) as Map<String, dynamic>;
    final mainLocaleLanguageName = mainLocaleLanguages[lang] as String;
    final mainLocaleCountryName = mainLocaleCountries[country] as String?;
    final nativeLocaleLanguageName = localeLanguages[lang] as String;
    final nativeLocaleCountryName = localeCountries[country] as String?;
    localeMap[(lang, country)] = (mainLocaleLanguageName, mainLocaleCountryName, nativeLocaleLanguageName, nativeLocaleCountryName);
  }
  const localeNameMapName = "_localeNameMap";
  final localeNameMap = declareConst(localeNameMapName)
    .assign(literalConstMap(localeMap.map((k, v) {
      final key = literalRecord([k.$1, k.$2], {});
      final value = literalRecord([v.$1, v.$2 ?? "", v.$3, v.$4 ?? ""], {});
      return MapEntry(key, value);
    })))
    .statement;
  final localeExtension = Extension((b) => b
    ..name = 'LocaleNames'
    ..on = refer('Locale')
    ..methods.add(Method((b) => b
      ..lambda = true
      ..type = MethodType.getter
      ..name = 'defaultDisplayLanguage'
      ..body = const Code("$localeNameMapName[(languageCode, countryCode)]!.\$1")
      ..returns = refer('String')),
    )
    ..methods.add(Method((b) => b
      ..lambda = true
      ..type = MethodType.getter
      ..name = 'defaultDisplayCountry'
      ..body = const Code("$localeNameMapName[(languageCode, countryCode)]!.\$2")
      ..returns = refer('String')),
    )
    ..methods.add(Method((b) => b
      ..lambda = true
      ..type = MethodType.getter
      ..name = 'nativeDisplayLanguage'
      ..body = const Code("$localeNameMapName[(languageCode, countryCode)]!.\$3")
      ..returns = refer('String')),
    )
    ..methods.add(Method((b) => b
      ..lambda = true
      ..type = MethodType.getter
      ..name = 'nativeDisplayCountry'
      ..body = const Code("$localeNameMapName[(languageCode, countryCode)]!.\$4")
      ..returns = refer('String')),
    )
  );
  final emitter = DartEmitter();
  final dartfmt = DartFormatter();
  final targetFile = File("lib/generated/locale_names.dart");
  final sink = targetFile.openWrite();
  sink.write("import 'dart:ui';\n\n");
  sink.write(dartfmt.format(localeNameMap.accept(emitter).toString()));
  sink.write(dartfmt.format(localeExtension.accept(emitter).toString()));
  sink.close();
}



