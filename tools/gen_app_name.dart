// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart'; // ignore: uri_does_not_exist, depend_on_referenced_packages
import 'package:xml/xpath.dart'; // ignore: uri_does_not_exist, depend_on_referenced_packages
import 'package:yaml/yaml.dart'; // ignore: uri_does_not_exist, depend_on_referenced_packages

const androidValuesPath = "android/app/src/main/res/values";
const stringsXmlName = "strings.xml";
const stringsXmlTpl = """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="appName">{{APP_NAME}}</string>
</resources>
""";

void main() async {
  final pubspecFile = File("pubspec.yaml");
  final pubspec = loadYaml(await pubspecFile.readAsString());
  final mainLocale = pubspec["flutter_intl"]["main_locale"] as String;
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
    final appName = arb["app_name"];
    if (appName is! String) {
      continue;
    }
    late final String valuesPath;
    if (locale == mainLocale) {
      valuesPath = androidValuesPath;
    } else {
      final [lang, ...rest] = locale.split(RegExp(r'[_-]'));
      final country = rest.firstOrNull;
      if (country == null) {
        valuesPath = "$androidValuesPath-$lang";
      } else {
        valuesPath = "$androidValuesPath-$lang-r$country";
      }
    }
    final stringsXmlFile = File("$valuesPath/$stringsXmlName");
    if (await stringsXmlFile.exists()) {
      final stringsXml = XmlDocument.parse(await stringsXmlFile.readAsString());
      final appNameNodes = stringsXml.xpath('/resources/string[@name="appName"]');
      if (appNameNodes.length != 1) {
        print("{$stringsXmlFile.path} contains more than one appName string value!");
        continue;
      }
      final appNameNode = appNameNodes.first;
      appNameNode.children
        ..clear()
        ..add(XmlText(appName));
      stringsXmlFile.writeAsString(stringsXml.toString());
    } else {
      await Directory(valuesPath).create(recursive: true);
      final stringsXmlContent = stringsXmlTpl.replaceAll("{{APP_NAME}}", appName);
      stringsXmlFile.writeAsString(stringsXmlContent);
    }
  }
}
