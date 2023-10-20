// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "alert_neutral": MessageLookupByLibrary.simpleMessage("OK"),
        "inject_missing_hax_extdata": MessageLookupByLibrary.simpleMessage(
            "Broken mset9 setup, extdata is missing"),
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
        "pick_id0_not_1": MessageLookupByLibrary.simpleMessage(
            "There\'s no ID0 or more than one ID0 folder, please check"),
        "pick_multi_hax_id1": MessageLookupByLibrary.simpleMessage(
            "There\'s more than one hax ID1 ???"),
        "pick_picked_id1": MessageLookupByLibrary.simpleMessage(
            "ID1 picked, please pick ID0 or Nintendo 3DS folder instead"),
        "pick_picked_unknown": MessageLookupByLibrary.simpleMessage(
            "Unknown folder picked, please pick correct folder"),
        "remove_loading":
            MessageLookupByLibrary.simpleMessage("Removing MSET9 ..."),
        "setup_alert_dummy_db_corrupted": MessageLookupByLibrary.simpleMessage(
            "Title database is likely corrupted."),
        "setup_alert_dummy_db_created": MessageLookupByLibrary.simpleMessage(
            "A dummy title database has been created."),
        "setup_alert_dummy_db_failed": MessageLookupByLibrary.simpleMessage(
            "Failed to create dummy title database"),
        "setup_alert_dummy_db_found":
            MessageLookupByLibrary.simpleMessage("Dummy title database found."),
        "setup_alert_dummy_db_prompt": MessageLookupByLibrary.simpleMessage(
            "Title database not found. Do you want this app to create it for you? (A title database is necessary for this exploit to run.)"),
        "setup_alert_dummy_db_prompt_no":
            MessageLookupByLibrary.simpleMessage("Cancel"),
        "setup_alert_dummy_db_prompt_yes":
            MessageLookupByLibrary.simpleMessage("Yes"),
        "setup_alert_dummy_db_reset": MessageLookupByLibrary.simpleMessage(
            "Put sd card back to your 3ds, power it on, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset."),
        "setup_alert_dummy_db_title": MessageLookupByLibrary.simpleMessage(
            "Setup Error - Dummy Title Database"),
        "setup_alert_dummy_db_visual_aid":
            MessageLookupByLibrary.simpleMessage("Visual Aid"),
        "setup_alert_dummy_db_visual_aid_url":
            MessageLookupByLibrary.simpleMessage(
                "https://3ds.hacks.guide/images/screenshots/database-reset.jpg"),
        "setup_alert_extdata_home_menu":
            MessageLookupByLibrary.simpleMessage("There\'s no Home Menu Data"),
        "setup_alert_extdata_mii_maker":
            MessageLookupByLibrary.simpleMessage("There\'s no Mii Maker Data"),
        "setup_alert_extdata_missing":
            MessageLookupByLibrary.simpleMessage("There\'s no Extra Data"),
        "setup_alert_extdata_title":
            MessageLookupByLibrary.simpleMessage("Setup Error - Extra Data"),
        "setup_alert_no_or_more_id1": MessageLookupByLibrary.simpleMessage(
            "There\'s no ID1 folder or multiple ID1 folders!"),
        "setup_alert_setup_title":
            MessageLookupByLibrary.simpleMessage("Setup Error"),
        "setup_loading":
            MessageLookupByLibrary.simpleMessage("Setting up MSET9 ..."),
        "title_installer":
            MessageLookupByLibrary.simpleMessage("MSET9 Installer"),
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
