// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_translation_contribution": MessageLookupByLibrary.simpleMessage(
            "If you want to contribute to translations (non en/en_US), please go https://crowdin.com/project/mset9_installer"),
        "alert_action_troubleshooting":
            MessageLookupByLibrary.simpleMessage("トラブルシューティング"),
        "alert_confirm_title": MessageLookupByLibrary.simpleMessage("確認"),
        "alert_error_title": MessageLookupByLibrary.simpleMessage("エラー"),
        "alert_general_cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "alert_general_confirm": MessageLookupByLibrary.simpleMessage("確認"),
        "alert_general_no": MessageLookupByLibrary.simpleMessage("いいえ"),
        "alert_general_troubleshooting_url":
            MessageLookupByLibrary.simpleMessage(
                "https://3ds.hacks.guide/troubleshooting-mset9.html"),
        "alert_general_yes": MessageLookupByLibrary.simpleMessage("はい"),
        "alert_info_title": MessageLookupByLibrary.simpleMessage("お知らせ"),
        "alert_neutral": MessageLookupByLibrary.simpleMessage("確定"),
        "alert_not_supported": MessageLookupByLibrary.simpleMessage(
            "Your browser is not supported, please use different browser or different version of installer."),
        "alert_not_supported_title":
            MessageLookupByLibrary.simpleMessage("サポートされていません"),
        "alert_warning_title": MessageLookupByLibrary.simpleMessage("ご注意"),
        "app_name": MessageLookupByLibrary.simpleMessage("MSET9 インストーラー"),
        "check_loading": MessageLookupByLibrary.simpleMessage("確認中…"),
        "installer_button_check":
            MessageLookupByLibrary.simpleMessage("Check MSET9 status"),
        "installer_button_check_sd":
            MessageLookupByLibrary.simpleMessage("Check SD card"),
        "installer_button_dummy_checking":
            MessageLookupByLibrary.simpleMessage("確認中…"),
        "installer_button_inject_trigger":
            MessageLookupByLibrary.simpleMessage("トリガーファイルを投入する"),
        "installer_button_pick_3ds":
            MessageLookupByLibrary.simpleMessage("\"Nintendo 3DS\" フォルダを選択する"),
        "installer_button_pick_sd":
            MessageLookupByLibrary.simpleMessage("SDカードを選択する"),
        "installer_button_remove":
            MessageLookupByLibrary.simpleMessage("MEST9を削除する"),
        "installer_button_remove_trigger":
            MessageLookupByLibrary.simpleMessage("トリガーファイルを削除する"),
        "installer_button_setup":
            MessageLookupByLibrary.simpleMessage("MEST9をセットアップする"),
        "menu_advance": MessageLookupByLibrary.simpleMessage("Advance Options"),
        "menu_alert_language_action":
            MessageLookupByLibrary.simpleMessage("Done"),
        "menu_alert_language_title":
            MessageLookupByLibrary.simpleMessage("Select Language"),
        "menu_credit": MessageLookupByLibrary.simpleMessage("クレジット"),
        "menu_extra": MessageLookupByLibrary.simpleMessage("Extra Versions"),
        "menu_force_dark_mode": MessageLookupByLibrary.simpleMessage("ダークモード"),
        "menu_force_light_mode": MessageLookupByLibrary.simpleMessage("ライトモード"),
        "menu_language": MessageLookupByLibrary.simpleMessage("Language"),
        "menu_legacy": MessageLookupByLibrary.simpleMessage("Legacy Hax ID1"),
        "menu_log": MessageLookupByLibrary.simpleMessage("ログ"),
        "menu_loose_root_check":
            MessageLookupByLibrary.simpleMessage("Loose Root Check"),
        "pick_alert_stage_name": MessageLookupByLibrary.simpleMessage("フォルダー"),
        "pick_broken_id0_contents": MessageLookupByLibrary.simpleMessage(
            "Something goes very wrong inside your ID0 folder. Please check."),
        "pick_common_n3ds_info": MessageLookupByLibrary.simpleMessage(
            "Ensure that you put SD card in the console and boot normally first.\nDon\'t try to create Nintendo 3DS folder yourself."),
        "pick_multi_hax_id1":
            MessageLookupByLibrary.simpleMessage("1つ以上のハックスID1がありますか?"),
        "pick_multiple_id0":
            MessageLookupByLibrary.simpleMessage("複数のID0フォルダがあります。確認してください。"),
        "pick_no_id0": MessageLookupByLibrary.simpleMessage(
            "Not valid Nintendo 3DS folder. There\'s no ID0 folder inside."),
        "pick_no_n3ds": MessageLookupByLibrary.simpleMessage(
            "There\'s no Nintendo 3DS folder."),
        "pick_picked_id1": MessageLookupByLibrary.simpleMessage(
            "ID1 picked, please pick ID0 or Nintendo 3DS folder instead.\n(Pick the upper folder, which contains the folder that you just picked, instead.)"),
        "pick_picked_unknown": MessageLookupByLibrary.simpleMessage(
            "不明なフォルダが選択されました。正しいフォルダを選択してください."),
        "remove_alert_action_repick":
            MessageLookupByLibrary.simpleMessage("Repick"),
        "remove_alert_confirm": MessageLookupByLibrary.simpleMessage(
            "It seems that you haven\'t installed boot9strap yet, are you sure you want to remove MSET9?\n\nIf you picked wrong model/version, you can click Repick to pick again."),
        "remove_alert_stage_name": MessageLookupByLibrary.simpleMessage("削除"),
        "remove_arc_hax_id1_removal_failure": MessageLookupByLibrary.simpleMessage(
            "Failed to remove hax ID1 automatically due to bug in ChromeOS Android implementation.\nYou can try removing it again.\nIf it keep failing, you\'ll need to remove it manually."),
        "remove_loading":
            MessageLookupByLibrary.simpleMessage("MEST9を削除する ..."),
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
        "setup_alert_dummy_db_failed":
            MessageLookupByLibrary.simpleMessage("ダミータイトルデータベースの作成に失敗しました"),
        "setup_alert_dummy_db_found":
            MessageLookupByLibrary.simpleMessage("ダミータイトルデータベースが見つかりました。"),
        "setup_alert_dummy_db_reset": MessageLookupByLibrary.simpleMessage(
            "Sdカードを3DSに戻し電源を入れます。 次に、システム設定 - データ管理 - Nintendo 3DS - ソフトウェア - リセットに移動します。"),
        "setup_alert_dummy_db_subtitle":
            MessageLookupByLibrary.simpleMessage("ダミータイトルデータベース"),
        "setup_alert_dummy_db_visual_aid":
            MessageLookupByLibrary.simpleMessage("視覚支援"),
        "setup_alert_dummy_db_visual_aid_url":
            MessageLookupByLibrary.simpleMessage(
                "https://3ds.hacks.guide/images/screenshots/database-reset.jpg"),
        "setup_alert_dummy_mii_maker_and_db_reset":
            MessageLookupByLibrary.simpleMessage(
                "Put SD card back to your 3ds, power it on, then open Mii Maker.\nAfter Mii Maker loaded, press HOME, then navigate to System Settings -> Data Management -> Nintendo 3DS -> Software -> Reset."),
        "setup_alert_extdata_home_menu":
            MessageLookupByLibrary.simpleMessage("ホームメニューのデータがありません"),
        "setup_alert_extdata_mii_maker":
            MessageLookupByLibrary.simpleMessage("Miiメーカーのデータがありません"),
        "setup_alert_extdata_missing":
            MessageLookupByLibrary.simpleMessage("追加データがありません"),
        "setup_alert_extdata_subtitle":
            MessageLookupByLibrary.simpleMessage("追加データ"),
        "setup_alert_hax_id1_created":
            MessageLookupByLibrary.simpleMessage("Hax ID1 has been created."),
        "setup_alert_hax_id1_created_title":
            MessageLookupByLibrary.simpleMessage("Hax ID1 Created"),
        "setup_alert_multiple_id1":
            MessageLookupByLibrary.simpleMessage("複数のID1フォルダがあります。確認してください。"),
        "setup_alert_no_hax_available": MessageLookupByLibrary.simpleMessage(
            "Not supported for your system version"),
        "setup_alert_no_hax_available_subtitle":
            MessageLookupByLibrary.simpleMessage("Unsupported Version"),
        "setup_alert_no_id1": MessageLookupByLibrary.simpleMessage(
            "Not valid Nintendo 3DS folder. There\'s no ID1 folder inside."),
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
        "setup_alert_stage_name":
            MessageLookupByLibrary.simpleMessage("セットアップ"),
        "setup_loading":
            MessageLookupByLibrary.simpleMessage("MEST9をセットアップする ..."),
        "title_variant_selector":
            MessageLookupByLibrary.simpleMessage("Select Model & Version"),
        "variant_selector_model_new":
            MessageLookupByLibrary.simpleMessage("New 3DS/2DS"),
        "variant_selector_model_old":
            MessageLookupByLibrary.simpleMessage("Old 3DS/2DS"),
        "variant_selector_version":
            MessageLookupByLibrary.simpleMessage("システムバージョンを選択してください:")
      };
}
