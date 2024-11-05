// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `OK`
  String get alert_neutral {
    return Intl.message(
      'OK',
      name: 'alert_neutral',
      desc: '',
      args: [],
    );
  }

  /// `MSET9 Installer`
  String get title_installer {
    return Intl.message(
      'MSET9 Installer',
      name: 'title_installer',
      desc: '',
      args: [],
    );
  }

  /// `Select Model & Version`
  String get title_variant_selector {
    return Intl.message(
      'Select Model & Version',
      name: 'title_variant_selector',
      desc: '',
      args: [],
    );
  }

  /// `Select Your SD Card`
  String get installer_button_pick_sd {
    return Intl.message(
      'Select Your SD Card',
      name: 'installer_button_pick_sd',
      desc: '',
      args: [],
    );
  }

  /// `Select "Nintendo 3DS"`
  String get installer_button_pick_3ds {
    return Intl.message(
      'Select "Nintendo 3DS"',
      name: 'installer_button_pick_3ds',
      desc: '',
      args: [],
    );
  }

  /// `Check MSET9 status`
  String get installer_button_check {
    return Intl.message(
      'Check MSET9 status',
      name: 'installer_button_check',
      desc: '',
      args: [],
    );
  }

  /// `Setup MSET9`
  String get installer_button_setup {
    return Intl.message(
      'Setup MSET9',
      name: 'installer_button_setup',
      desc: '',
      args: [],
    );
  }

  /// `Inject trigger file`
  String get installer_button_inject_trigger {
    return Intl.message(
      'Inject trigger file',
      name: 'installer_button_inject_trigger',
      desc: '',
      args: [],
    );
  }

  /// `Remove trigger file`
  String get installer_button_remove_trigger {
    return Intl.message(
      'Remove trigger file',
      name: 'installer_button_remove_trigger',
      desc: '',
      args: [],
    );
  }

  /// `Remove MSET9`
  String get installer_button_remove {
    return Intl.message(
      'Remove MSET9',
      name: 'installer_button_remove',
      desc: '',
      args: [],
    );
  }

  /// `ID1 picked, please pick ID0 or Nintendo 3DS folder instead`
  String get pick_picked_id1 {
    return Intl.message(
      'ID1 picked, please pick ID0 or Nintendo 3DS folder instead',
      name: 'pick_picked_id1',
      desc: '',
      args: [],
    );
  }

  /// `Unknown folder picked, please pick correct folder`
  String get pick_picked_unknown {
    return Intl.message(
      'Unknown folder picked, please pick correct folder',
      name: 'pick_picked_unknown',
      desc: '',
      args: [],
    );
  }

  /// `There's no ID0 or more than one ID0 folder, please check`
  String get pick_id0_not_1 {
    return Intl.message(
      'There\'s no ID0 or more than one ID0 folder, please check',
      name: 'pick_id0_not_1',
      desc: '',
      args: [],
    );
  }

  /// `There's more than one hax ID1 ???`
  String get pick_multi_hax_id1 {
    return Intl.message(
      'There\'s more than one hax ID1 ???',
      name: 'pick_multi_hax_id1',
      desc: '',
      args: [],
    );
  }

  /// `Old 3DS/2DS`
  String get variant_selector_model_old {
    return Intl.message(
      'Old 3DS/2DS',
      name: 'variant_selector_model_old',
      desc: '',
      args: [],
    );
  }

  /// `New 3DS/2DS`
  String get variant_selector_model_new {
    return Intl.message(
      'New 3DS/2DS',
      name: 'variant_selector_model_new',
      desc: '',
      args: [],
    );
  }

  /// `Select System Version:`
  String get variant_selector_version {
    return Intl.message(
      'Select System Version:',
      name: 'variant_selector_version',
      desc: '',
      args: [],
    );
  }

  /// `Setting up MSET9 ...`
  String get setup_loading {
    return Intl.message(
      'Setting up MSET9 ...',
      name: 'setup_loading',
      desc: '',
      args: [],
    );
  }

  /// `Setup Error`
  String get setup_alert_setup_title {
    return Intl.message(
      'Setup Error',
      name: 'setup_alert_setup_title',
      desc: '',
      args: [],
    );
  }

  /// `There's no ID1 folder or multiple ID1 folders!`
  String get setup_alert_no_or_more_id1 {
    return Intl.message(
      'There\'s no ID1 folder or multiple ID1 folders!',
      name: 'setup_alert_no_or_more_id1',
      desc: '',
      args: [],
    );
  }

  /// `Setup Error - Extra Data`
  String get setup_alert_extdata_title {
    return Intl.message(
      'Setup Error - Extra Data',
      name: 'setup_alert_extdata_title',
      desc: '',
      args: [],
    );
  }

  /// `There's no Extra Data`
  String get setup_alert_extdata_missing {
    return Intl.message(
      'There\'s no Extra Data',
      name: 'setup_alert_extdata_missing',
      desc: '',
      args: [],
    );
  }

  /// `There's no Home Menu Data`
  String get setup_alert_extdata_home_menu {
    return Intl.message(
      'There\'s no Home Menu Data',
      name: 'setup_alert_extdata_home_menu',
      desc: '',
      args: [],
    );
  }

  /// `There's no Mii Maker Data`
  String get setup_alert_extdata_mii_maker {
    return Intl.message(
      'There\'s no Mii Maker Data',
      name: 'setup_alert_extdata_mii_maker',
      desc: '',
      args: [],
    );
  }

  /// `Setup Error - Dummy Title Database`
  String get setup_alert_dummy_db_title {
    return Intl.message(
      'Setup Error - Dummy Title Database',
      name: 'setup_alert_dummy_db_title',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get setup_alert_dummy_db_prompt_yes {
    return Intl.message(
      'Yes',
      name: 'setup_alert_dummy_db_prompt_yes',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get setup_alert_dummy_db_prompt_no {
    return Intl.message(
      'Cancel',
      name: 'setup_alert_dummy_db_prompt_no',
      desc: '',
      args: [],
    );
  }

  /// `Setup - Hax ID1 Created`
  String get setup_alert_hax_id1_created_title {
    return Intl.message(
      'Setup - Hax ID1 Created',
      name: 'setup_alert_hax_id1_created_title',
      desc: '',
      args: [],
    );
  }

  /// `Hax ID1 has been created.`
  String get setup_alert_hax_id1_created {
    return Intl.message(
      'Hax ID1 has been created.',
      name: 'setup_alert_hax_id1_created',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create dummy title database`
  String get setup_alert_dummy_db_failed {
    return Intl.message(
      'Failed to create dummy title database',
      name: 'setup_alert_dummy_db_failed',
      desc: '',
      args: [],
    );
  }

  /// `Visual Aid`
  String get setup_alert_dummy_db_visual_aid {
    return Intl.message(
      'Visual Aid',
      name: 'setup_alert_dummy_db_visual_aid',
      desc: '',
      args: [],
    );
  }

  /// `https://3ds.hacks.guide/images/screenshots/database-reset.jpg`
  String get setup_alert_dummy_db_visual_aid_url {
    return Intl.message(
      'https://3ds.hacks.guide/images/screenshots/database-reset.jpg',
      name: 'setup_alert_dummy_db_visual_aid_url',
      desc: '',
      args: [],
    );
  }

  /// `Dummy title database found.`
  String get setup_alert_dummy_db_found {
    return Intl.message(
      'Dummy title database found.',
      name: 'setup_alert_dummy_db_found',
      desc: '',
      args: [],
    );
  }

  /// `Title database is likely corrupted.`
  String get setup_alert_dummy_db_corrupted {
    return Intl.message(
      'Title database is likely corrupted.',
      name: 'setup_alert_dummy_db_corrupted',
      desc: '',
      args: [],
    );
  }

  /// `Put sd card back to your 3ds, power it on, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset.`
  String get setup_alert_dummy_db_reset {
    return Intl.message(
      'Put sd card back to your 3ds, power it on, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset.',
      name: 'setup_alert_dummy_db_reset',
      desc: '',
      args: [],
    );
  }

  /// `Put sd card back to your 3ds, power it on, then open Mii Maker.\nAfter Mii Maker loaded, press HOME, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset.`
  String get setup_alert_dummy_mii_maker_and_db_reset {
    return Intl.message(
      'Put sd card back to your 3ds, power it on, then open Mii Maker.\nAfter Mii Maker loaded, press HOME, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset.',
      name: 'setup_alert_dummy_mii_maker_and_db_reset',
      desc: '',
      args: [],
    );
  }

  /// `Broken mset9 setup, extdata is missing`
  String get inject_missing_hax_extdata {
    return Intl.message(
      'Broken mset9 setup, extdata is missing',
      name: 'inject_missing_hax_extdata',
      desc: '',
      args: [],
    );
  }

  /// `Removing MSET9 ...`
  String get remove_loading {
    return Intl.message(
      'Removing MSET9 ...',
      name: 'remove_loading',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
