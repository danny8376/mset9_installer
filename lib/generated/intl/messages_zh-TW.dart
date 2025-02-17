// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_TW locale. All the
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
  String get localeName => 'zh_TW';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_translation_contribution": MessageLookupByLibrary.simpleMessage(
            "如果你想要貢獻翻譯(非 en/en_US)，請前往 https://crowdin.com/project/mset9_installer"),
        "alert_action_troubleshooting":
            MessageLookupByLibrary.simpleMessage("疑難排解"),
        "alert_confirm_title": MessageLookupByLibrary.simpleMessage("確認"),
        "alert_error_title": MessageLookupByLibrary.simpleMessage("錯誤"),
        "alert_general_cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "alert_general_confirm": MessageLookupByLibrary.simpleMessage("確認"),
        "alert_general_no": MessageLookupByLibrary.simpleMessage("否"),
        "alert_general_troubleshooting_url":
            MessageLookupByLibrary.simpleMessage(
                "https://3ds.hacks.guide/troubleshooting-mset9.html"),
        "alert_general_yes": MessageLookupByLibrary.simpleMessage("是"),
        "alert_info_title": MessageLookupByLibrary.simpleMessage("資訊"),
        "alert_neutral": MessageLookupByLibrary.simpleMessage("好"),
        "alert_not_supported": MessageLookupByLibrary.simpleMessage(
            "你的瀏覽器不相容，請使用不同的瀏覽器或者其他版本的安裝工具。"),
        "alert_not_supported_title":
            MessageLookupByLibrary.simpleMessage("不相容"),
        "alert_warning_title": MessageLookupByLibrary.simpleMessage("警告"),
        "app_name": MessageLookupByLibrary.simpleMessage("MSET9 安裝工具"),
        "check_loading": MessageLookupByLibrary.simpleMessage("檢查中…"),
        "installer_button_check":
            MessageLookupByLibrary.simpleMessage("確認 MSET9 狀態"),
        "installer_button_check_sd":
            MessageLookupByLibrary.simpleMessage("確認 SD 卡"),
        "installer_button_dummy_checking":
            MessageLookupByLibrary.simpleMessage("檢查中…"),
        "installer_button_inject_trigger":
            MessageLookupByLibrary.simpleMessage("注入觸發檔案"),
        "installer_button_pick_3ds":
            MessageLookupByLibrary.simpleMessage("選取 \"Nintendo 3DS\" 資料夾"),
        "installer_button_pick_sd":
            MessageLookupByLibrary.simpleMessage("選取 SD 卡"),
        "installer_button_remove":
            MessageLookupByLibrary.simpleMessage("移除 MSET9"),
        "installer_button_remove_trigger":
            MessageLookupByLibrary.simpleMessage("移除觸發檔案"),
        "installer_button_setup":
            MessageLookupByLibrary.simpleMessage("設置 MSET9"),
        "menu_advance": MessageLookupByLibrary.simpleMessage("進階選項"),
        "menu_alert_language_action":
            MessageLookupByLibrary.simpleMessage("完成"),
        "menu_alert_language_title":
            MessageLookupByLibrary.simpleMessage("選擇語言"),
        "menu_credit": MessageLookupByLibrary.simpleMessage("感謝"),
        "menu_extra": MessageLookupByLibrary.simpleMessage("延伸版本支援"),
        "menu_force_dark_mode": MessageLookupByLibrary.simpleMessage("深色模式"),
        "menu_force_light_mode": MessageLookupByLibrary.simpleMessage("淺色模式"),
        "menu_language": MessageLookupByLibrary.simpleMessage("語言設定"),
        "menu_legacy": MessageLookupByLibrary.simpleMessage("使用舊版漏洞ID1"),
        "menu_log": MessageLookupByLibrary.simpleMessage("日誌"),
        "menu_loose_root_check":
            MessageLookupByLibrary.simpleMessage("寬鬆根目錄檢查"),
        "pick_alert_stage_name": MessageLookupByLibrary.simpleMessage("選取"),
        "pick_broken_id0_contents":
            MessageLookupByLibrary.simpleMessage("ID0 有問題，請確認"),
        "pick_common_n3ds_info": MessageLookupByLibrary.simpleMessage(
            "請把 SD 卡放回你的主機並正常開機\n請勿自行建立 Nintendo 3DS 資料夾"),
        "pick_multi_hax_id1":
            MessageLookupByLibrary.simpleMessage("有多個漏洞 ID1 !?"),
        "pick_multiple_id0":
            MessageLookupByLibrary.simpleMessage("有多個 ID0 存在，請確認"),
        "pick_no_id0": MessageLookupByLibrary.simpleMessage(
            "並非有效的 Nintendo 3DS 資料夾，找不到 ID0"),
        "pick_no_n3ds":
            MessageLookupByLibrary.simpleMessage("Nintendo 3DS 資料夾不存在"),
        "pick_picked_id1": MessageLookupByLibrary.simpleMessage(
            "選取了 ID1，請選取 ID0 或者 Nintendo 3DS 資料夾\n(請選取上層資料夾)"),
        "pick_picked_unknown":
            MessageLookupByLibrary.simpleMessage("選取了未知資料夾，請選擇正確的資料夾"),
        "remove_alert_action_repick":
            MessageLookupByLibrary.simpleMessage("重新選擇"),
        "remove_alert_confirm": MessageLookupByLibrary.simpleMessage(
            "看起來你還沒成功安裝 boot9strap，確定要移除 MSET9 嗎？\n\n如果你選擇了錯誤的型號或系統版本，可以點選\"重新選擇\"再次選取"),
        "remove_alert_stage_name": MessageLookupByLibrary.simpleMessage("移除"),
        "remove_arc_hax_id1_removal_failure": MessageLookupByLibrary.simpleMessage(
            "Failed to remove hax ID1 automatically due to bug in ChromeOS Android implementation.\nYou can try removing it again.\nIf it keep failing, you\'ll need to remove it manually."),
        "remove_loading": MessageLookupByLibrary.simpleMessage("移除 MSET9 ..."),
        "sd_setup_loading": MessageLookupByLibrary.simpleMessage("正在設置 SD ..."),
        "setup_alert_disclaimer": MessageLookupByLibrary.simpleMessage(
            "這個過程會暫時初始化你的大部分主機資料\n大部分的遊戲及主題會暫時消失\n這是完全正常的狀況，如果一切運作正常，它們會在結束時復原\n\n不論如何，仍然建議你備份 SD 卡上的資料到你的電腦或裝置上\n(特別是 Nintendo 3DS 資料夾)"),
        "setup_alert_disclaimer_confirm_to_continue":
            MessageLookupByLibrary.simpleMessage("點選確認以繼續"),
        "setup_alert_disclaimer_linux_addition":
            MessageLookupByLibrary.simpleMessage(
                "(在 Linux 上，較有可能有問題 - 請確保你的 SD 卡使用 utf8 選項掛載)"),
        "setup_alert_disclaimer_title":
            MessageLookupByLibrary.simpleMessage("免責聲明"),
        "setup_alert_disclaimer_web_addition":
            MessageLookupByLibrary.simpleMessage(
                "(因為網頁 API 的限制，此實作有稍高的機率會造成資料損毀，因此更加建議你進行備份)"),
        "setup_alert_dummy_db_corrupted":
            MessageLookupByLibrary.simpleMessage("安裝資料庫可能已經損毀"),
        "setup_alert_dummy_db_failed":
            MessageLookupByLibrary.simpleMessage("無法建立假安裝資料庫"),
        "setup_alert_dummy_db_found":
            MessageLookupByLibrary.simpleMessage("偵測到假安裝資料庫"),
        "setup_alert_dummy_db_reset": MessageLookupByLibrary.simpleMessage(
            "將 SD 卡放回主機後開機，然後進入主機設定⮕資料管理⮕Nintendo 3DS⮕軟體⮕重設"),
        "setup_alert_dummy_db_subtitle":
            MessageLookupByLibrary.simpleMessage("假安裝資料庫"),
        "setup_alert_dummy_db_visual_aid":
            MessageLookupByLibrary.simpleMessage("參考圖片"),
        "setup_alert_dummy_db_visual_aid_url":
            MessageLookupByLibrary.simpleMessage(
                "https://3ds.hacks.guide/images/screenshots/database-reset.jpg"),
        "setup_alert_dummy_mii_maker_and_db_reset":
            MessageLookupByLibrary.simpleMessage(
                "將 SD 卡放回主機後開機，開啟 Mii 工作室\nMii 工作室完成載入後，按下 HOME 鍵，然後進入主機設定⮕資料管理⮕Nintendo 3DS⮕軟體⮕重設"),
        "setup_alert_extdata_home_menu":
            MessageLookupByLibrary.simpleMessage("找不到HOME 選單新增資料"),
        "setup_alert_extdata_mii_maker":
            MessageLookupByLibrary.simpleMessage("找不到 Mii 工作室新增資料"),
        "setup_alert_extdata_missing":
            MessageLookupByLibrary.simpleMessage("找不到新增資料"),
        "setup_alert_extdata_subtitle":
            MessageLookupByLibrary.simpleMessage("新增資料"),
        "setup_alert_hax_id1_created":
            MessageLookupByLibrary.simpleMessage("已成功建立漏洞 ID1"),
        "setup_alert_hax_id1_created_title":
            MessageLookupByLibrary.simpleMessage("已建立漏洞 ID1"),
        "setup_alert_multiple_id1":
            MessageLookupByLibrary.simpleMessage("有多個 ID1 存在，請確認"),
        "setup_alert_no_hax_available":
            MessageLookupByLibrary.simpleMessage("不支援所選取的系統版本"),
        "setup_alert_no_hax_available_subtitle":
            MessageLookupByLibrary.simpleMessage("不支援的版本"),
        "setup_alert_no_id1": MessageLookupByLibrary.simpleMessage(
            "並非有效的 Nintendo 3DS 資料夾，找不到 ID1"),
        "setup_alert_repick_variant_prompt":
            MessageLookupByLibrary.simpleMessage("確定要選取不同的型號或系統版本嗎？"),
        "setup_alert_sd_setup_action_setup":
            MessageLookupByLibrary.simpleMessage("設置 SD 卡"),
        "setup_alert_sd_setup_failed":
            MessageLookupByLibrary.simpleMessage("無法自動設置 SD 卡！"),
        "setup_alert_sd_setup_file_missing":
            MessageLookupByLibrary.simpleMessage("以下的 SD 卡的檔案缺少、損毀或遺失："),
        "setup_alert_sd_setup_file_state_missing":
            MessageLookupByLibrary.simpleMessage("缺少"),
        "setup_alert_sd_setup_file_state_optional":
            MessageLookupByLibrary.simpleMessage("可選"),
        "setup_alert_sd_setup_file_state_outdated":
            MessageLookupByLibrary.simpleMessage("須更新"),
        "setup_alert_sd_setup_file_state_required":
            MessageLookupByLibrary.simpleMessage("必要"),
        "setup_alert_sd_setup_file_state_unknown_corrupted":
            MessageLookupByLibrary.simpleMessage("損毀/未知"),
        "setup_alert_sd_setup_optional_prompt":
            MessageLookupByLibrary.simpleMessage(
                "要自動下載損毀/未知/非關鍵的檔案嗎?\n(這會自動覆蓋相關檔案)"),
        "setup_alert_stage_name": MessageLookupByLibrary.simpleMessage("設置"),
        "setup_loading": MessageLookupByLibrary.simpleMessage("正在設置 MSET9 ..."),
        "title_variant_selector":
            MessageLookupByLibrary.simpleMessage("請選擇型號及主機板本"),
        "variant_selector_model_new":
            MessageLookupByLibrary.simpleMessage("新 3DS/2DS"),
        "variant_selector_model_old":
            MessageLookupByLibrary.simpleMessage("舊 3DS/2DS"),
        "variant_selector_version":
            MessageLookupByLibrary.simpleMessage("選擇系統版本:")
      };
}
