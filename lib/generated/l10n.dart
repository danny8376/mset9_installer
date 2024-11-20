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

  /// `MSET9 Installer`
  String get title_installer {
    return Intl.message(
      'MSET9 Installer',
      name: 'title_installer',
      desc: '',
      args: [],
    );
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

  /// `Yes`
  String get alert_general_yes {
    return Intl.message(
      'Yes',
      name: 'alert_general_yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get alert_general_no {
    return Intl.message(
      'No',
      name: 'alert_general_no',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get alert_general_confirm {
    return Intl.message(
      'Confirm',
      name: 'alert_general_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get alert_general_cancel {
    return Intl.message(
      'Cancel',
      name: 'alert_general_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Troubleshooting`
  String get alert_action_troubleshooting {
    return Intl.message(
      'Troubleshooting',
      name: 'alert_action_troubleshooting',
      desc: '',
      args: [],
    );
  }

  /// `https://3ds.hacks.guide/troubleshooting-mset9.html`
  String get alert_general_troubleshooting_url {
    return Intl.message(
      'https://3ds.hacks.guide/troubleshooting-mset9.html',
      name: 'alert_general_troubleshooting_url',
      desc: '',
      args: [],
    );
  }

  /// `Not Supported`
  String get alert_not_supported_title {
    return Intl.message(
      'Not Supported',
      name: 'alert_not_supported_title',
      desc: '',
      args: [],
    );
  }

  /// `Your browser is not supported, please use different browser or different version of installer.`
  String get alert_not_supported {
    return Intl.message(
      'Your browser is not supported, please use different browser or different version of installer.',
      name: 'alert_not_supported',
      desc: '',
      args: [],
    );
  }

  /// `Credit`
  String get menu_credit {
    return Intl.message(
      'Credit',
      name: 'menu_credit',
      desc: '',
      args: [],
    );
  }

  /// `Advance Options`
  String get menu_advance {
    return Intl.message(
      'Advance Options',
      name: 'menu_advance',
      desc: '',
      args: [],
    );
  }

  /// `Extra Versions`
  String get menu_extra {
    return Intl.message(
      'Extra Versions',
      name: 'menu_extra',
      desc: '',
      args: [],
    );
  }

  /// `Loose Root Check`
  String get menu_loose_root_check {
    return Intl.message(
      'Loose Root Check',
      name: 'menu_loose_root_check',
      desc: '',
      args: [],
    );
  }

  /// `Legacy Hax ID1`
  String get menu_legacy {
    return Intl.message(
      'Legacy Hax ID1',
      name: 'menu_legacy',
      desc: '',
      args: [],
    );
  }

  /// `Logs`
  String get menu_log {
    return Intl.message(
      'Logs',
      name: 'menu_log',
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

  /// `Checking...`
  String get installer_button_dummy_checking {
    return Intl.message(
      'Checking...',
      name: 'installer_button_dummy_checking',
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

  /// `Folder Picking - Error`
  String get pick_alert_title {
    return Intl.message(
      'Folder Picking - Error',
      name: 'pick_alert_title',
      desc: '',
      args: [],
    );
  }

  /// `There's no Nintendo 3DS folder.`
  String get pick_no_n3ds {
    return Intl.message(
      'There\'s no Nintendo 3DS folder.',
      name: 'pick_no_n3ds',
      desc: '',
      args: [],
    );
  }

  /// `There's no ID0 folder.`
  String get pick_no_id0 {
    return Intl.message(
      'There\'s no ID0 folder.',
      name: 'pick_no_id0',
      desc: '',
      args: [],
    );
  }

  /// `Ensure that you put SD card in the console and boot normally first.\nDon't try to create Nintendo 3DS folder yourself.`
  String get pick_common_n3ds_info {
    return Intl.message(
      'Ensure that you put SD card in the console and boot normally first.\nDon\'t try to create Nintendo 3DS folder yourself.',
      name: 'pick_common_n3ds_info',
      desc: '',
      args: [],
    );
  }

  /// `There's more than one ID0 folder, please check.`
  String get pick_multiple_id0 {
    return Intl.message(
      'There\'s more than one ID0 folder, please check.',
      name: 'pick_multiple_id0',
      desc: '',
      args: [],
    );
  }

  /// `ID1 picked, please pick ID0 or Nintendo 3DS folder instead.\n(Pick the upper folder, which contains the folder that you just picked, instead.)`
  String get pick_picked_id1 {
    return Intl.message(
      'ID1 picked, please pick ID0 or Nintendo 3DS folder instead.\n(Pick the upper folder, which contains the folder that you just picked, instead.)',
      name: 'pick_picked_id1',
      desc: '',
      args: [],
    );
  }

  /// `Unknown folder picked, please pick the correct folder.`
  String get pick_picked_unknown {
    return Intl.message(
      'Unknown folder picked, please pick the correct folder.',
      name: 'pick_picked_unknown',
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

  /// `Setup - Confirm`
  String get setup_alert_confirm_title {
    return Intl.message(
      'Setup - Confirm',
      name: 'setup_alert_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `Setup - Warning`
  String get setup_alert_warning_title {
    return Intl.message(
      'Setup - Warning',
      name: 'setup_alert_warning_title',
      desc: '',
      args: [],
    );
  }

  /// `Setup Error`
  String get setup_alert_error_title {
    return Intl.message(
      'Setup Error',
      name: 'setup_alert_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Disclaimer`
  String get setup_alert_disclaimer_title {
    return Intl.message(
      'Disclaimer',
      name: 'setup_alert_disclaimer_title',
      desc: '',
      args: [],
    );
  }

  /// `This process will temporarily reset all your 3DS data.\nMost of your applications and themes will disappear.\nThis is perfectly normal, and if everything goes right, it will re-appear at the end of the process.\n\nIn any case, it is highly recommended to make a backup of your SD card's contents to a folder on your PC/Device.\n(Especially the 'Nintendo 3DS' folder.)`
  String get setup_alert_disclaimer {
    return Intl.message(
      'This process will temporarily reset all your 3DS data.\nMost of your applications and themes will disappear.\nThis is perfectly normal, and if everything goes right, it will re-appear at the end of the process.\n\nIn any case, it is highly recommended to make a backup of your SD card\'s contents to a folder on your PC/Device.\n(Especially the \'Nintendo 3DS\' folder.)',
      name: 'setup_alert_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `(On Linux, things like to not go right - please ensure that your SD card is mounted with the 'utf8' option.)`
  String get setup_alert_disclaimer_linux_addition {
    return Intl.message(
      '(On Linux, things like to not go right - please ensure that your SD card is mounted with the \'utf8\' option.)',
      name: 'setup_alert_disclaimer_linux_addition',
      desc: '',
      args: [],
    );
  }

  /// `(Due to web api limitation, this implementation have slightly higher risk of data corruption, thus backup is even more recommended.)`
  String get setup_alert_disclaimer_web_addition {
    return Intl.message(
      '(Due to web api limitation, this implementation have slightly higher risk of data corruption, thus backup is even more recommended.)',
      name: 'setup_alert_disclaimer_web_addition',
      desc: '',
      args: [],
    );
  }

  /// `Press confirm to continue.`
  String get setup_alert_disclaimer_confirm_to_continue {
    return Intl.message(
      'Press confirm to continue.',
      name: 'setup_alert_disclaimer_confirm_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to automatically download corrupted/unknown/non-critical files?`
  String get setup_alert_sd_setup_optional_prompt {
    return Intl.message(
      'Do you want to automatically download corrupted/unknown/non-critical files?',
      name: 'setup_alert_sd_setup_optional_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Failed to setup SD root automatically!`
  String get setup_alert_sd_setup_failed {
    return Intl.message(
      'Failed to setup SD root automatically!',
      name: 'setup_alert_sd_setup_failed',
      desc: '',
      args: [],
    );
  }

  /// `Missing`
  String get setup_alert_sd_setup_file_state_missing {
    return Intl.message(
      'Missing',
      name: 'setup_alert_sd_setup_file_state_missing',
      desc: '',
      args: [],
    );
  }

  /// `Outdated`
  String get setup_alert_sd_setup_file_state_outdated {
    return Intl.message(
      'Outdated',
      name: 'setup_alert_sd_setup_file_state_outdated',
      desc: '',
      args: [],
    );
  }

  /// `Corrupted/Unknown`
  String get setup_alert_sd_setup_file_state_unknown_corrupted {
    return Intl.message(
      'Corrupted/Unknown',
      name: 'setup_alert_sd_setup_file_state_unknown_corrupted',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get setup_alert_sd_setup_file_state_required {
    return Intl.message(
      'Required',
      name: 'setup_alert_sd_setup_file_state_required',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get setup_alert_sd_setup_file_state_optional {
    return Intl.message(
      'Optional',
      name: 'setup_alert_sd_setup_file_state_optional',
      desc: '',
      args: [],
    );
  }

  /// `The following files on your sd root are missing/corrupted/unknown:`
  String get setup_alert_sd_setup_file_missing {
    return Intl.message(
      'The following files on your sd root are missing/corrupted/unknown:',
      name: 'setup_alert_sd_setup_file_missing',
      desc: '',
      args: [],
    );
  }

  /// `Do SD Setup`
  String get setup_alert_sd_setup_action_setup {
    return Intl.message(
      'Do SD Setup',
      name: 'setup_alert_sd_setup_action_setup',
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

  /// `Are you sure you want to pick different model/version?`
  String get setup_alert_repick_variant_prompt {
    return Intl.message(
      'Are you sure you want to pick different model/version?',
      name: 'setup_alert_repick_variant_prompt',
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

  /// `Remove - Confirm`
  String get remove_alert_confirm_title {
    return Intl.message(
      'Remove - Confirm',
      name: 'remove_alert_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `It seems that you haven't installed boot9strap yet, are you sure you want to remove MSET9?\n\nIf you picked wrong model/version, you can click Repick to pick again.`
  String get remove_alert_confirm {
    return Intl.message(
      'It seems that you haven\'t installed boot9strap yet, are you sure you want to remove MSET9?\n\nIf you picked wrong model/version, you can click Repick to pick again.',
      name: 'remove_alert_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Repick`
  String get remove_alert_action_repick {
    return Intl.message(
      'Repick',
      name: 'remove_alert_action_repick',
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
