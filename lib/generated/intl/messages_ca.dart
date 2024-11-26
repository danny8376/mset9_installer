// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ca locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ca';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_translation_contribution": MessageLookupByLibrary.simpleMessage(
            "If you want to contribute to translations (non en/en_US), please go https://crowdin.com/project/mset9_installer"),
        "alert_action_troubleshooting":
            MessageLookupByLibrary.simpleMessage("Troubleshooting"),
        "alert_general_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "alert_general_confirm":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "alert_general_no": MessageLookupByLibrary.simpleMessage("No"),
        "alert_general_troubleshooting_url":
            MessageLookupByLibrary.simpleMessage(
                "https://3ds.hacks.guide/troubleshooting-mset9.html"),
        "alert_general_yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "alert_neutral": MessageLookupByLibrary.simpleMessage("OK"),
        "alert_not_supported": MessageLookupByLibrary.simpleMessage(
            "Your browser is not supported, please use different browser or different version of installer."),
        "alert_not_supported_title":
            MessageLookupByLibrary.simpleMessage("Not Supported"),
        "app_name": MessageLookupByLibrary.simpleMessage("MSET9 Installer"),
        "check_loading": MessageLookupByLibrary.simpleMessage("Checking ..."),
        "installer_button_check":
            MessageLookupByLibrary.simpleMessage("Check MSET9 status"),
        "installer_button_dummy_checking":
            MessageLookupByLibrary.simpleMessage("Checking..."),
        "installer_button_inject_trigger":
            MessageLookupByLibrary.simpleMessage("Inject trigger file"),
        "installer_button_pick_3ds":
            MessageLookupByLibrary.simpleMessage("Select \"Nintendo 3DS\""),
        "installer_button_pick_sd":
            MessageLookupByLibrary.simpleMessage("Select Your SD Card"),
        "installer_button_remove":
            MessageLookupByLibrary.simpleMessage("Remove MSET9"),
        "installer_button_remove_trigger":
            MessageLookupByLibrary.simpleMessage("Remove trigger file"),
        "installer_button_setup":
            MessageLookupByLibrary.simpleMessage("Setup MSET9"),
        "menu_advance": MessageLookupByLibrary.simpleMessage("Advance Options"),
        "menu_alert_language_action":
            MessageLookupByLibrary.simpleMessage("Done"),
        "menu_alert_language_title":
            MessageLookupByLibrary.simpleMessage("Select Language"),
        "menu_credit": MessageLookupByLibrary.simpleMessage("Credit"),
        "menu_extra": MessageLookupByLibrary.simpleMessage("Extra Versions"),
        "menu_force_dark_mode":
            MessageLookupByLibrary.simpleMessage("Dark Mode"),
        "menu_force_light_mode":
            MessageLookupByLibrary.simpleMessage("Light Mode"),
        "menu_language": MessageLookupByLibrary.simpleMessage("Language"),
        "menu_legacy": MessageLookupByLibrary.simpleMessage("Legacy Hax ID1"),
        "menu_log": MessageLookupByLibrary.simpleMessage("Logs"),
        "menu_loose_root_check":
            MessageLookupByLibrary.simpleMessage("Loose Root Check"),
        "pick_common_n3ds_info": MessageLookupByLibrary.simpleMessage(
            "Ensure that you put SD card in the console and boot normally first.\nDon\'t try to create Nintendo 3DS folder yourself."),
        "pick_multi_hax_id1": MessageLookupByLibrary.simpleMessage(
            "There\'s more than one hax ID1 ???"),
        "pick_multiple_id0": MessageLookupByLibrary.simpleMessage(
            "There\'s more than one ID0 folder, please check."),
        "pick_no_id0":
            MessageLookupByLibrary.simpleMessage("There\'s no ID0 folder."),
        "pick_no_n3ds": MessageLookupByLibrary.simpleMessage(
            "There\'s no Nintendo 3DS folder."),
        "pick_picked_id1": MessageLookupByLibrary.simpleMessage(
            "ID1 picked, please pick ID0 or Nintendo 3DS folder instead.\n(Pick the upper folder, which contains the folder that you just picked, instead.)"),
        "pick_picked_unknown": MessageLookupByLibrary.simpleMessage(
            "Unknown folder picked, please pick the correct folder."),
        "remove_alert_action_repick":
            MessageLookupByLibrary.simpleMessage("Repick"),
        "remove_alert_confirm": MessageLookupByLibrary.simpleMessage(
            "It seems that you haven\'t installed boot9strap yet, are you sure you want to remove MSET9?\n\nIf you picked wrong model/version, you can click Repick to pick again."),
        "remove_loading":
            MessageLookupByLibrary.simpleMessage("Removing MSET9 ..."),
        "sd_setup_loading":
            MessageLookupByLibrary.simpleMessage("Setting up SD ..."),
        "setup_alert_disclaimer": MessageLookupByLibrary.simpleMessage(
            "This process will temporarily reset most of your 3DS data.\nMost of your applications and themes will disappear.\nThis is perfectly normal, and if everything goes right, it will re-appear at the end of the process.\n\nIn any case, it is highly recommended to make a backup of your SD card\'s contents to a folder on your PC/Device.\n(Especially the \'Nintendo 3DS\' folder.)"),
        "setup_alert_disclaimer_confirm_to_continue":
            MessageLookupByLibrary.simpleMessage("Press confirm to continue."),
        "setup_alert_disclaimer_linux_addition":
            MessageLookupByLibrary.simpleMessage(
                "(On Linux, things like to not go right - please ensure that your SD card is mounted with the \'utf8\' option.)"),
        "setup_alert_disclaimer_title":
            MessageLookupByLibrary.simpleMessage("Disclaimer"),
        "setup_alert_disclaimer_web_addition": MessageLookupByLibrary.simpleMessage(
            "(Due to web api limitation, this implementation have slightly higher risk of data corruption, thus backup is even more recommended.)"),
        "setup_alert_dummy_db_corrupted": MessageLookupByLibrary.simpleMessage(
            "Title database is likely corrupted."),
        "setup_alert_dummy_db_failed": MessageLookupByLibrary.simpleMessage(
            "Failed to create dummy title database"),
        "setup_alert_dummy_db_found":
            MessageLookupByLibrary.simpleMessage("Dummy title database found."),
        "setup_alert_dummy_db_reset": MessageLookupByLibrary.simpleMessage(
            "Put SD card back to your 3ds, power it on, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset."),
        "setup_alert_dummy_db_visual_aid":
            MessageLookupByLibrary.simpleMessage("Visual Aid"),
        "setup_alert_dummy_db_visual_aid_url":
            MessageLookupByLibrary.simpleMessage(
                "https://3ds.hacks.guide/images/screenshots/database-reset.jpg"),
        "setup_alert_dummy_mii_maker_and_db_reset":
            MessageLookupByLibrary.simpleMessage(
                "Put SD card back to your 3ds, power it on, then open Mii Maker.\nAfter Mii Maker loaded, press HOME, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset."),
        "setup_alert_extdata_home_menu":
            MessageLookupByLibrary.simpleMessage("There\'s no Home Menu Data"),
        "setup_alert_extdata_mii_maker":
            MessageLookupByLibrary.simpleMessage("There\'s no Mii Maker Data"),
        "setup_alert_extdata_missing":
            MessageLookupByLibrary.simpleMessage("There\'s no Extra Data"),
        "setup_alert_hax_id1_created":
            MessageLookupByLibrary.simpleMessage("Hax ID1 has been created."),
        "setup_alert_hax_id1_created_title":
            MessageLookupByLibrary.simpleMessage("Setup - Hax ID1 Created"),
        "setup_alert_no_or_more_id1": MessageLookupByLibrary.simpleMessage(
            "There\'s no ID1 folder or multiple ID1 folders!"),
        "setup_alert_repick_variant_prompt":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to pick different model/version?"),
        "setup_alert_sd_setup_action_setup":
            MessageLookupByLibrary.simpleMessage("Do SD Setup"),
        "setup_alert_sd_setup_failed": MessageLookupByLibrary.simpleMessage(
            "Failed to setup SD root automatically!"),
        "setup_alert_sd_setup_file_missing": MessageLookupByLibrary.simpleMessage(
            "The following files on your SD root are missing/corrupted/unknown:"),
        "setup_alert_sd_setup_file_state_missing":
            MessageLookupByLibrary.simpleMessage("Missing"),
        "setup_alert_sd_setup_file_state_optional":
            MessageLookupByLibrary.simpleMessage("Optional"),
        "setup_alert_sd_setup_file_state_outdated":
            MessageLookupByLibrary.simpleMessage("Outdated"),
        "setup_alert_sd_setup_file_state_required":
            MessageLookupByLibrary.simpleMessage("Required"),
        "setup_alert_sd_setup_file_state_unknown_corrupted":
            MessageLookupByLibrary.simpleMessage("Corrupted/Unknown"),
        "setup_alert_sd_setup_optional_prompt":
            MessageLookupByLibrary.simpleMessage(
                "Do you want to automatically download corrupted/unknown/non-critical files? (This will overwrite all related files automatically)"),
        "setup_loading":
            MessageLookupByLibrary.simpleMessage("Setting up MSET9 ..."),
        "title_variant_selector":
            MessageLookupByLibrary.simpleMessage("Select Model & Version"),
        "variant_selector_model_new":
            MessageLookupByLibrary.simpleMessage("New 3DS/2DS"),
        "variant_selector_model_old":
            MessageLookupByLibrary.simpleMessage("Old 3DS/2DS"),
        "variant_selector_version":
            MessageLookupByLibrary.simpleMessage("Select System Version:")
      };
}
