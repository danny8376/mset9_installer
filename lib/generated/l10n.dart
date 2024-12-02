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

  /// `If you want to contribute to translations (non en/en_US), please go https://crowdin.com/project/mset9_installer`
  String get about_translation_contribution {
    return Intl.message(
      'If you want to contribute to translations (non en/en_US), please go https://crowdin.com/project/mset9_installer',
      name: 'about_translation_contribution',
      desc:
          'Not used in app, this is information for people who want to contribute to translations',
      args: [],
    );
  }

  /// `MSET9 Installer`
  String get app_name {
    return Intl.message(
      'MSET9 Installer',
      name: 'app_name',
      desc: 'Translated name of this app',
      args: [],
    );
  }

  /// `OK`
  String get alert_neutral {
    return Intl.message(
      'OK',
      name: 'alert_neutral',
      desc: 'Neutral action button for prompts without options',
      args: [],
    );
  }

  /// `Yes`
  String get alert_general_yes {
    return Intl.message(
      'Yes',
      name: 'alert_general_yes',
      desc: 'Positive action button for yes-no prompts',
      args: [],
    );
  }

  /// `No`
  String get alert_general_no {
    return Intl.message(
      'No',
      name: 'alert_general_no',
      desc: 'Negative action button for yes-no prompts',
      args: [],
    );
  }

  /// `Confirm`
  String get alert_general_confirm {
    return Intl.message(
      'Confirm',
      name: 'alert_general_confirm',
      desc: 'Positive action button for confirm-cancel prompts',
      args: [],
    );
  }

  /// `Cancel`
  String get alert_general_cancel {
    return Intl.message(
      'Cancel',
      name: 'alert_general_cancel',
      desc: 'Negative action button for confirm-cancel prompts',
      args: [],
    );
  }

  /// `Error`
  String get alert_error_title {
    return Intl.message(
      'Error',
      name: 'alert_error_title',
      desc:
          'Title for error prompts, if this combined with any *_stage_name will be too long for title, add ascii symbol \$ at the end to force stage name to use icons instead',
      args: [],
    );
  }

  /// `Warning`
  String get alert_warning_title {
    return Intl.message(
      'Warning',
      name: 'alert_warning_title',
      desc:
          'Title for warning prompts, if this combined with any *_stage_name will be too long for title, add ascii symbol \$ at the end to force stage name to use icons instead',
      args: [],
    );
  }

  /// `Info`
  String get alert_info_title {
    return Intl.message(
      'Info',
      name: 'alert_info_title',
      desc:
          'Title for information prompts, if this combined with any *_stage_name will be too long for title, add ascii symbol \$ at the end to force stage name to use icons instead',
      args: [],
    );
  }

  /// `Confirm`
  String get alert_confirm_title {
    return Intl.message(
      'Confirm',
      name: 'alert_confirm_title',
      desc:
          'Title for confirmation prompts, if this combined with any *_stage_name will be too long for title, add ascii symbol \$ at the end to force stage name to use icons instead',
      args: [],
    );
  }

  /// `Troubleshooting`
  String get alert_action_troubleshooting {
    return Intl.message(
      'Troubleshooting',
      name: 'alert_action_troubleshooting',
      desc: 'Button for opening troubleshooting page in error prompts',
      args: [],
    );
  }

  /// `https://3ds.hacks.guide/troubleshooting-mset9.html`
  String get alert_general_troubleshooting_url {
    return Intl.message(
      'https://3ds.hacks.guide/troubleshooting-mset9.html',
      name: 'alert_general_troubleshooting_url',
      desc:
          'Link to troubleshooting page of mset9 on 3ds.hacks.guide, should link to translated page when available',
      args: [],
    );
  }

  /// `Not Supported`
  String get alert_not_supported_title {
    return Intl.message(
      'Not Supported',
      name: 'alert_not_supported_title',
      desc: 'Title of not supported prompt used for web version',
      args: [],
    );
  }

  /// `Your browser is not supported, please use different browser or different version of installer.`
  String get alert_not_supported {
    return Intl.message(
      'Your browser is not supported, please use different browser or different version of installer.',
      name: 'alert_not_supported',
      desc: 'Message body of not supported prompt used for web version',
      args: [],
    );
  }

  /// `Credit`
  String get menu_credit {
    return Intl.message(
      'Credit',
      name: 'menu_credit',
      desc: 'Button in app menu for showing credit',
      args: [],
    );
  }

  /// `Language`
  String get menu_language {
    return Intl.message(
      'Language',
      name: 'menu_language',
      desc: 'Button in app menu for selecting language',
      args: [],
    );
  }

  /// `Light Mode`
  String get menu_force_light_mode {
    return Intl.message(
      'Light Mode',
      name: 'menu_force_light_mode',
      desc: 'Button in app menu for forcing use of light mode theme',
      args: [],
    );
  }

  /// `Dark Mode`
  String get menu_force_dark_mode {
    return Intl.message(
      'Dark Mode',
      name: 'menu_force_dark_mode',
      desc: 'Button in app menu for forcing use of dark mode theme',
      args: [],
    );
  }

  /// `Advance Options`
  String get menu_advance {
    return Intl.message(
      'Advance Options',
      name: 'menu_advance',
      desc:
          'Button in app menu for enabling hidden options that\'s only intended for advance users',
      args: [],
    );
  }

  /// `Extra Versions`
  String get menu_extra {
    return Intl.message(
      'Extra Versions',
      name: 'menu_extra',
      desc:
          'Button in advance only menu for enabling support of system version that covered by shoundhax',
      args: [],
    );
  }

  /// `Loose Root Check`
  String get menu_loose_root_check {
    return Intl.message(
      'Loose Root Check',
      name: 'menu_loose_root_check',
      desc:
          'Button in advance only menu for allowing missing/unknown SD root files that\'s not critical for mset9 itself',
      args: [],
    );
  }

  /// `Legacy Hax ID1`
  String get menu_legacy {
    return Intl.message(
      'Legacy Hax ID1',
      name: 'menu_legacy',
      desc:
          'Button in advance only menu for using original mset9 hax ID1 instead of the new ID1',
      args: [],
    );
  }

  /// `Logs`
  String get menu_log {
    return Intl.message(
      'Logs',
      name: 'menu_log',
      desc: 'Button in app menu for showing app logs',
      args: [],
    );
  }

  /// `Select Language`
  String get menu_alert_language_title {
    return Intl.message(
      'Select Language',
      name: 'menu_alert_language_title',
      desc: 'Title of language selection prompt',
      args: [],
    );
  }

  /// `Done`
  String get menu_alert_language_action {
    return Intl.message(
      'Done',
      name: 'menu_alert_language_action',
      desc: 'Neutral action button of language selection prompt',
      args: [],
    );
  }

  /// `Select your SD card`
  String get installer_button_pick_sd {
    return Intl.message(
      'Select your SD card',
      name: 'installer_button_pick_sd',
      desc: 'Button in main app screen for picking SD card',
      args: [],
    );
  }

  /// `Select "Nintendo 3DS"`
  String get installer_button_pick_3ds {
    return Intl.message(
      'Select "Nintendo 3DS"',
      name: 'installer_button_pick_3ds',
      desc:
          'Button in main app screen for picking Nintendo 3DS folder, only shown on Android',
      args: [],
    );
  }

  /// `Checking...`
  String get installer_button_dummy_checking {
    return Intl.message(
      'Checking...',
      name: 'installer_button_dummy_checking',
      desc:
          'Dummy non-clickable button in main app screen shown when the app is doing work (only really noticeable when doing check)',
      args: [],
    );
  }

  /// `Check SD card`
  String get installer_button_check_sd {
    return Intl.message(
      'Check SD card',
      name: 'installer_button_check_sd',
      desc:
          'Button in main app screen for rechecking picked SD card on desktop only',
      args: [],
    );
  }

  /// `Check MSET9 status`
  String get installer_button_check {
    return Intl.message(
      'Check MSET9 status',
      name: 'installer_button_check',
      desc: 'Button in main app screen for (re)checking setup status',
      args: [],
    );
  }

  /// `Setup MSET9`
  String get installer_button_setup {
    return Intl.message(
      'Setup MSET9',
      name: 'installer_button_setup',
      desc: 'Button in main app screen for setting up MSET9',
      args: [],
    );
  }

  /// `Inject trigger file`
  String get installer_button_inject_trigger {
    return Intl.message(
      'Inject trigger file',
      name: 'installer_button_inject_trigger',
      desc: 'Button in main app screen for injecting trigger file',
      args: [],
    );
  }

  /// `Remove trigger file`
  String get installer_button_remove_trigger {
    return Intl.message(
      'Remove trigger file',
      name: 'installer_button_remove_trigger',
      desc: 'Button in main app screen for removing trigger file',
      args: [],
    );
  }

  /// `Remove MSET9`
  String get installer_button_remove {
    return Intl.message(
      'Remove MSET9',
      name: 'installer_button_remove',
      desc: 'Button in main app screen for removing MSET9',
      args: [],
    );
  }

  /// `Folder`
  String get pick_alert_stage_name {
    return Intl.message(
      'Folder',
      name: 'pick_alert_stage_name',
      desc:
          'Stage name next to title for folder/SD card picking related prompts, if this combined with all general (error/warning/info/confirm) will be too long for title, set this to @ to force stage name to use icons instead',
      args: [],
    );
  }

  /// `There's no Nintendo 3DS folder.`
  String get pick_no_n3ds {
    return Intl.message(
      'There\'s no Nintendo 3DS folder.',
      name: 'pick_no_n3ds',
      desc:
          'Message body of prompt when the folder they pick don\'t have Nintendo 3DS folder, will append pick_common_n3ds_info at the end (with empty line)',
      args: [],
    );
  }

  /// `Not valid Nintendo 3DS folder. There's no ID0 folder inside.`
  String get pick_no_id0 {
    return Intl.message(
      'Not valid Nintendo 3DS folder. There\'s no ID0 folder inside.',
      name: 'pick_no_id0',
      desc:
          'Message body of prompt when the folder they pick have no ID0 folder inside Nintendo 3DS folder, will append pick_common_n3ds_info at the end (with empty line)',
      args: [],
    );
  }

  /// `Ensure that you put SD card in the console and boot normally first.\nDon't try to create Nintendo 3DS folder yourself.`
  String get pick_common_n3ds_info {
    return Intl.message(
      'Ensure that you put SD card in the console and boot normally first.\nDon\'t try to create Nintendo 3DS folder yourself.',
      name: 'pick_common_n3ds_info',
      desc:
          'Additional message about Nintendo 3DS folder generation that get appended after pick_no_n3ds and pick_no_id0',
      args: [],
    );
  }

  /// `There's more than one ID0 folder, please check.`
  String get pick_multiple_id0 {
    return Intl.message(
      'There\'s more than one ID0 folder, please check.',
      name: 'pick_multiple_id0',
      desc:
          'Message body of prompt when the folder they pick have multiple ID0 folders inside Nintendo 3DS folder',
      args: [],
    );
  }

  /// `Not valid Nintendo 3DS folder. There's no ID1 folder inside.`
  String get setup_alert_no_id1 {
    return Intl.message(
      'Not valid Nintendo 3DS folder. There\'s no ID1 folder inside.',
      name: 'setup_alert_no_id1',
      desc:
          'Message body of error prompt when there\'s no or multiple ID1 folder',
      args: [],
    );
  }

  /// `There's more than one ID1 folder. Please check.`
  String get setup_alert_multiple_id1 {
    return Intl.message(
      'There\'s more than one ID1 folder. Please check.',
      name: 'setup_alert_multiple_id1',
      desc:
          'Message body of error prompt when there\'s no or multiple ID1 folder',
      args: [],
    );
  }

  /// `ID1 picked, please pick ID0 or Nintendo 3DS folder instead.\n(Pick the upper folder, which contains the folder that you just picked, instead.)`
  String get pick_picked_id1 {
    return Intl.message(
      'ID1 picked, please pick ID0 or Nintendo 3DS folder instead.\n(Pick the upper folder, which contains the folder that you just picked, instead.)',
      name: 'pick_picked_id1',
      desc:
          'Message body of prompt when the folder they pick is ID1, with hint of where ID0 is',
      args: [],
    );
  }

  /// `Unknown folder picked, please pick the correct folder.`
  String get pick_picked_unknown {
    return Intl.message(
      'Unknown folder picked, please pick the correct folder.',
      name: 'pick_picked_unknown',
      desc:
          'Message body of prompt when the folder they pick is unrelated (or subfolders inside ID1 or other location)',
      args: [],
    );
  }

  /// `Something goes very wrong inside your ID0 folder. Please check.`
  String get pick_broken_id0_contents {
    return Intl.message(
      'Something goes very wrong inside your ID0 folder. Please check.',
      name: 'pick_broken_id0_contents',
      desc:
          'Message body of prompt when it\'s very broken (only hax ID1 without ID1 backup or only ID1 backup but no hax ID1)',
      args: [],
    );
  }

  /// `There's more than one hax ID1 ???`
  String get pick_multi_hax_id1 {
    return Intl.message(
      'There\'s more than one hax ID1 ???',
      name: 'pick_multi_hax_id1',
      desc:
          'Message body of prompt when the ID0 folder contains multiple hax ID1 folder',
      args: [],
    );
  }

  /// `Select Model & Version`
  String get title_variant_selector {
    return Intl.message(
      'Select Model & Version',
      name: 'title_variant_selector',
      desc: 'Title of variant (model and system version) selector',
      args: [],
    );
  }

  /// `Old 3DS/2DS`
  String get variant_selector_model_old {
    return Intl.message(
      'Old 3DS/2DS',
      name: 'variant_selector_model_old',
      desc:
          'Table header for old model Nintendo 3DS/2DS series, prefer to be short if possible',
      args: [],
    );
  }

  /// `New 3DS/2DS`
  String get variant_selector_model_new {
    return Intl.message(
      'New 3DS/2DS',
      name: 'variant_selector_model_new',
      desc:
          'Table header for New Nintendo 3DS/2DS series, prefer to be short if possible',
      args: [],
    );
  }

  /// `Select System Version:`
  String get variant_selector_version {
    return Intl.message(
      'Select System Version:',
      name: 'variant_selector_version',
      desc: 'Help text above version selector in variant selector',
      args: [],
    );
  }

  /// `Checking ...`
  String get check_loading {
    return Intl.message(
      'Checking ...',
      name: 'check_loading',
      desc: 'Not used, text in loading prompt when checking',
      args: [],
    );
  }

  /// `Setting up MSET9 ...`
  String get setup_loading {
    return Intl.message(
      'Setting up MSET9 ...',
      name: 'setup_loading',
      desc: 'Text in loading prompt when setting up MSET9 hax ID1',
      args: [],
    );
  }

  /// `Setting up SD ...`
  String get sd_setup_loading {
    return Intl.message(
      'Setting up SD ...',
      name: 'sd_setup_loading',
      desc: 'Text in loading prompt when setting up SD root files',
      args: [],
    );
  }

  /// `Setup`
  String get setup_alert_stage_name {
    return Intl.message(
      'Setup',
      name: 'setup_alert_stage_name',
      desc:
          'Stage name next to title for prompts related to MSET9 setup, if this combined with all general (error/warning/info/confirm) will be too long for title, set this to @ to force stage name to use icons instead',
      args: [],
    );
  }

  /// `Disclaimer`
  String get setup_alert_disclaimer_title {
    return Intl.message(
      'Disclaimer',
      name: 'setup_alert_disclaimer_title',
      desc: 'Title of disclaimer prompt about their console data (on SD card)',
      args: [],
    );
  }

  /// `This process will temporarily reset most of your 3DS data.\nMost of your applications and themes will disappear.\nThis is perfectly normal, and if everything goes right, it will re-appear at the end of the process.\n\nIn any case, it is highly recommended to make a backup of your SD card's contents to a folder on your PC/Device.\n(Especially the 'Nintendo 3DS' folder.)`
  String get setup_alert_disclaimer {
    return Intl.message(
      'This process will temporarily reset most of your 3DS data.\nMost of your applications and themes will disappear.\nThis is perfectly normal, and if everything goes right, it will re-appear at the end of the process.\n\nIn any case, it is highly recommended to make a backup of your SD card\'s contents to a folder on your PC/Device.\n(Especially the \'Nintendo 3DS\' folder.)',
      name: 'setup_alert_disclaimer',
      desc:
          'Message body of disclaimer prompt about their console data (on SD card)',
      args: [],
    );
  }

  /// `(On Linux, things like to not go right - please ensure that your SD card is mounted with the 'utf8' option.)`
  String get setup_alert_disclaimer_linux_addition {
    return Intl.message(
      '(On Linux, things like to not go right - please ensure that your SD card is mounted with the \'utf8\' option.)',
      name: 'setup_alert_disclaimer_linux_addition',
      desc: 'Additional message of disclaimer prompt about Linux',
      args: [],
    );
  }

  /// `(Due to web api limitation, this implementation have slightly higher risk of data corruption, thus backup is even more recommended.)`
  String get setup_alert_disclaimer_web_addition {
    return Intl.message(
      '(Due to web api limitation, this implementation have slightly higher risk of data corruption, thus backup is even more recommended.)',
      name: 'setup_alert_disclaimer_web_addition',
      desc: 'Additional message of disclaimer prompt about web version',
      args: [],
    );
  }

  /// `Press confirm to continue.`
  String get setup_alert_disclaimer_confirm_to_continue {
    return Intl.message(
      'Press confirm to continue.',
      name: 'setup_alert_disclaimer_confirm_to_continue',
      desc:
          'Additional message at the end of disclaimer prompt tell them to confirm',
      args: [],
    );
  }

  /// `Unsupported Version`
  String get setup_alert_no_hax_available_subtitle {
    return Intl.message(
      'Unsupported Version',
      name: 'setup_alert_no_hax_available_subtitle',
      desc: 'Subtitle of prompt when unsupported version picked',
      args: [],
    );
  }

  /// `Not supported for your system version`
  String get setup_alert_no_hax_available {
    return Intl.message(
      'Not supported for your system version',
      name: 'setup_alert_no_hax_available',
      desc: 'Message body of prompt when unsupported version picked',
      args: [],
    );
  }

  /// `Do you want to automatically download corrupted/unknown/non-critical files? (This will overwrite all related files automatically)`
  String get setup_alert_sd_setup_optional_prompt {
    return Intl.message(
      'Do you want to automatically download corrupted/unknown/non-critical files? (This will overwrite all related files automatically)',
      name: 'setup_alert_sd_setup_optional_prompt',
      desc:
          'Message body of yes-no prompt that only shown when loose SD root check enabled and have some missing/unknown files, ask if they want to auto download and replace them',
      args: [],
    );
  }

  /// `Failed to setup SD root automatically!`
  String get setup_alert_sd_setup_failed {
    return Intl.message(
      'Failed to setup SD root automatically!',
      name: 'setup_alert_sd_setup_failed',
      desc: 'Message body of error prompt when SD root setup failed',
      args: [],
    );
  }

  /// `Missing`
  String get setup_alert_sd_setup_file_state_missing {
    return Intl.message(
      'Missing',
      name: 'setup_alert_sd_setup_file_state_missing',
      desc:
          'State text of missing file within file list in SD root file missing prompt',
      args: [],
    );
  }

  /// `Outdated`
  String get setup_alert_sd_setup_file_state_outdated {
    return Intl.message(
      'Outdated',
      name: 'setup_alert_sd_setup_file_state_outdated',
      desc:
          'State text of outdated file within file list in SD root file missing prompt',
      args: [],
    );
  }

  /// `Corrupted/Unknown`
  String get setup_alert_sd_setup_file_state_unknown_corrupted {
    return Intl.message(
      'Corrupted/Unknown',
      name: 'setup_alert_sd_setup_file_state_unknown_corrupted',
      desc:
          'State text of unknown/corrupted file within file list in SD root file missing prompt',
      args: [],
    );
  }

  /// `Required`
  String get setup_alert_sd_setup_file_state_required {
    return Intl.message(
      'Required',
      name: 'setup_alert_sd_setup_file_state_required',
      desc:
          'Additional text after file state that indicate it\'s required file, only shown when loose SD root file check enabled',
      args: [],
    );
  }

  /// `Optional`
  String get setup_alert_sd_setup_file_state_optional {
    return Intl.message(
      'Optional',
      name: 'setup_alert_sd_setup_file_state_optional',
      desc: 'Additional text after file state that indicate it\'s optional',
      args: [],
    );
  }

  /// `The following files on your SD root are missing/corrupted/unknown:`
  String get setup_alert_sd_setup_file_missing {
    return Intl.message(
      'The following files on your SD root are missing/corrupted/unknown:',
      name: 'setup_alert_sd_setup_file_missing',
      desc: 'Leading text before file list in SD root file missing prompt',
      args: [],
    );
  }

  /// `Do SD Setup`
  String get setup_alert_sd_setup_action_setup {
    return Intl.message(
      'Do SD Setup',
      name: 'setup_alert_sd_setup_action_setup',
      desc: 'Action button for doing auto SD root setup in file missing prompt',
      args: [],
    );
  }

  /// `Extra Data`
  String get setup_alert_extdata_subtitle {
    return Intl.message(
      'Extra Data',
      name: 'setup_alert_extdata_subtitle',
      desc: 'Subtitle of prompt for extra data related errors during setup',
      args: [],
    );
  }

  /// `There's no Extra Data`
  String get setup_alert_extdata_missing {
    return Intl.message(
      'There\'s no Extra Data',
      name: 'setup_alert_extdata_missing',
      desc: 'Message body of error prompt when there\'s no extdata folder',
      args: [],
    );
  }

  /// `There's no Home Menu Data`
  String get setup_alert_extdata_home_menu {
    return Intl.message(
      'There\'s no Home Menu Data',
      name: 'setup_alert_extdata_home_menu',
      desc:
          'Message body of error prompt when there\'s no home menu extra data',
      args: [],
    );
  }

  /// `There's no Mii Maker Data`
  String get setup_alert_extdata_mii_maker {
    return Intl.message(
      'There\'s no Mii Maker Data',
      name: 'setup_alert_extdata_mii_maker',
      desc:
          'Message body of error prompt when there\'s no Mii Maker extra data',
      args: [],
    );
  }

  /// `Dummy Title Database`
  String get setup_alert_dummy_db_subtitle {
    return Intl.message(
      'Dummy Title Database',
      name: 'setup_alert_dummy_db_subtitle',
      desc: 'Subtitle of prompt for dummy title database',
      args: [],
    );
  }

  /// `Are you sure you want to pick different model/version?`
  String get setup_alert_repick_variant_prompt {
    return Intl.message(
      'Are you sure you want to pick different model/version?',
      name: 'setup_alert_repick_variant_prompt',
      desc:
          'Message body of confirmation prompt for repick variant (model/version)',
      args: [],
    );
  }

  /// `Failed to create dummy title database`
  String get setup_alert_dummy_db_failed {
    return Intl.message(
      'Failed to create dummy title database',
      name: 'setup_alert_dummy_db_failed',
      desc:
          'Message body of error prompt when failed to create dummy title database',
      args: [],
    );
  }

  /// `Visual Aid`
  String get setup_alert_dummy_db_visual_aid {
    return Intl.message(
      'Visual Aid',
      name: 'setup_alert_dummy_db_visual_aid',
      desc: 'Action button for opening visual aid for resetting dummy database',
      args: [],
    );
  }

  /// `https://3ds.hacks.guide/images/screenshots/database-reset.jpg`
  String get setup_alert_dummy_db_visual_aid_url {
    return Intl.message(
      'https://3ds.hacks.guide/images/screenshots/database-reset.jpg',
      name: 'setup_alert_dummy_db_visual_aid_url',
      desc:
          'Link to visual aid for resetting dummy database, currently no translated version so don\'t change, if you want to offer translated version, please reach https://github.com/hacks-guide/Guide_3DS, also take care of cases of people using non-native region consoles',
      args: [],
    );
  }

  /// `Dummy title database found.`
  String get setup_alert_dummy_db_found {
    return Intl.message(
      'Dummy title database found.',
      name: 'setup_alert_dummy_db_found',
      desc:
          'Title of error prompt when there\'s dummy title database, setup_alert_dummy_db_reset will be appended after, after extra empty line',
      args: [],
    );
  }

  /// `Title database is likely corrupted.`
  String get setup_alert_dummy_db_corrupted {
    return Intl.message(
      'Title database is likely corrupted.',
      name: 'setup_alert_dummy_db_corrupted',
      desc:
          'Title of error prompt when the title database is likely corrupted, setup_alert_dummy_db_reset will be appended after, after extra empty line',
      args: [],
    );
  }

  /// `Put SD card back to your 3ds, power it on, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset.`
  String get setup_alert_dummy_db_reset {
    return Intl.message(
      'Put SD card back to your 3ds, power it on, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset.',
      name: 'setup_alert_dummy_db_reset',
      desc:
          'Common text for instruction of resetting dummy/corrupted title database, appended after setup_alert_dummy_db_found and setup_alert_dummy_db_corrupted with extra empty line',
      args: [],
    );
  }

  /// `Hax ID1 Created`
  String get setup_alert_hax_id1_created_title {
    return Intl.message(
      'Hax ID1 Created',
      name: 'setup_alert_hax_id1_created_title',
      desc: 'Title of prompt after MSET9 set up',
      args: [],
    );
  }

  /// `Hax ID1 has been created.`
  String get setup_alert_hax_id1_created {
    return Intl.message(
      'Hax ID1 has been created.',
      name: 'setup_alert_hax_id1_created',
      desc:
          'Message body of prompt after MSET9 set up, setup_alert_dummy_mii_maker_and_db_reset will be appended after extra empty line',
      args: [],
    );
  }

  /// `Put SD card back to your 3ds, power it on, then open Mii Maker.\nAfter Mii Maker loaded, press HOME, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset.`
  String get setup_alert_dummy_mii_maker_and_db_reset {
    return Intl.message(
      'Put SD card back to your 3ds, power it on, then open Mii Maker.\nAfter Mii Maker loaded, press HOME, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset.',
      name: 'setup_alert_dummy_mii_maker_and_db_reset',
      desc:
          'Similar to setup_alert_dummy_db_reset, but with mii maker extra data instruction, appended after setup_alert_hax_id1_created with extra empty line',
      args: [],
    );
  }

  /// `Removing MSET9 ...`
  String get remove_loading {
    return Intl.message(
      'Removing MSET9 ...',
      name: 'remove_loading',
      desc: 'Text in loading prompt when removing MSET9',
      args: [],
    );
  }

  /// `Remove`
  String get remove_alert_stage_name {
    return Intl.message(
      'Remove',
      name: 'remove_alert_stage_name',
      desc:
          'Stage name next to title for MSET9 removal related prompts, if this combined with all general (error/warning/info/confirm) will be too long for title, set this to @ to force stage name to use icons instead',
      args: [],
    );
  }

  /// `It seems that you haven't installed boot9strap yet, are you sure you want to remove MSET9?\n\nIf you picked wrong model/version, you can click Repick to pick again.`
  String get remove_alert_confirm {
    return Intl.message(
      'It seems that you haven\'t installed boot9strap yet, are you sure you want to remove MSET9?\n\nIf you picked wrong model/version, you can click Repick to pick again.',
      name: 'remove_alert_confirm',
      desc:
          'Message body of confirmation prompt when try to remove mset9 before boot9strap installed, also tell them they can simply change variant if they picked it wrong',
      args: [],
    );
  }

  /// `Repick`
  String get remove_alert_action_repick {
    return Intl.message(
      'Repick',
      name: 'remove_alert_action_repick',
      desc:
          'Action button for re-picking variant inside removal confirmation prompt',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'af'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'ca'),
      Locale.fromSubtags(languageCode: 'cs'),
      Locale.fromSubtags(languageCode: 'da'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'el'),
      Locale.fromSubtags(languageCode: 'es-ES'),
      Locale.fromSubtags(languageCode: 'fi'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'he'),
      Locale.fromSubtags(languageCode: 'hu'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'no'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt-BR'),
      Locale.fromSubtags(languageCode: 'pt-PT'),
      Locale.fromSubtags(languageCode: 'ro'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'sr'),
      Locale.fromSubtags(languageCode: 'sv-SE'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'uk'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh-CN'),
      Locale.fromSubtags(languageCode: 'zh-TW'),
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
