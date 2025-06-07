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
            "翻訳(英語以外)に貢献したい場合は、 https://crowdin.com/project/mset9_installer をご覧ください。"),
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
            "お使いのブラウザはサポートされていません。別のブラウザまたは別のバージョンのインストーラをご利用ください。"),
        "alert_not_supported_title":
            MessageLookupByLibrary.simpleMessage("サポートされていません"),
        "alert_warning_title": MessageLookupByLibrary.simpleMessage("ご注意"),
        "app_name": MessageLookupByLibrary.simpleMessage("MSET9 インストーラー"),
        "check_loading": MessageLookupByLibrary.simpleMessage("確認中…"),
        "installer_button_check":
            MessageLookupByLibrary.simpleMessage("MSET9の状態確認"),
        "installer_button_check_sd":
            MessageLookupByLibrary.simpleMessage("SDカードをチェック"),
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
        "menu_advance": MessageLookupByLibrary.simpleMessage("高度な設定"),
        "menu_alert_language_action":
            MessageLookupByLibrary.simpleMessage("完了"),
        "menu_alert_language_title":
            MessageLookupByLibrary.simpleMessage("言語を選択"),
        "menu_credit": MessageLookupByLibrary.simpleMessage("クレジット"),
        "menu_extra": MessageLookupByLibrary.simpleMessage("追加のバージョンサポートを有効"),
        "menu_force_dark_mode": MessageLookupByLibrary.simpleMessage("ダークモード"),
        "menu_force_light_mode": MessageLookupByLibrary.simpleMessage("ライトモード"),
        "menu_language": MessageLookupByLibrary.simpleMessage("言語"),
        "menu_legacy": MessageLookupByLibrary.simpleMessage("レガシーhax ID1を使用"),
        "menu_log": MessageLookupByLibrary.simpleMessage("ログ"),
        "menu_loose_root_check":
            MessageLookupByLibrary.simpleMessage("ルートディレクトリチェックを緩和"),
        "pick_alert_stage_name": MessageLookupByLibrary.simpleMessage("フォルダー"),
        "pick_broken_id0_contents": MessageLookupByLibrary.simpleMessage(
            "ID0フォルダに重大な問題があります。確認してください。"),
        "pick_common_n3ds_info": MessageLookupByLibrary.simpleMessage(
            "まず、SDカードをゲーム機に挿入して通常通り起動してください。\n自分でNintendo 3DSフォルダを作ろうとしないでください。"),
        "pick_multi_hax_id1":
            MessageLookupByLibrary.simpleMessage("1つ以上のハックスID1がありますか?"),
        "pick_multiple_id0":
            MessageLookupByLibrary.simpleMessage("複数のID0フォルダがあります。確認してください。"),
        "pick_no_id0": MessageLookupByLibrary.simpleMessage(
            "このNintendo 3DSフォルダは使えません。ID0フォルダが入っていません。"),
        "pick_no_n3ds":
            MessageLookupByLibrary.simpleMessage("Nintendo 3DSフォルダではありません。"),
        "pick_picked_id1": MessageLookupByLibrary.simpleMessage(
            "ID0を選んでください。選択されたフォルダはID1です。\n(一つ上の階層のフォルダを選んでください。)"),
        "pick_picked_unknown": MessageLookupByLibrary.simpleMessage(
            "不明なフォルダが選択されました。正しいフォルダを選択してください."),
        "remove_alert_action_repick":
            MessageLookupByLibrary.simpleMessage("再選択"),
        "remove_alert_confirm": MessageLookupByLibrary.simpleMessage(
            "boot9strap がまだインストールされていません。MSET9 を削除してもよろしいですか?\n\n機種やバージョンをまちがえた場合は、「再選択」をクリックしてください。"),
        "remove_alert_stage_name": MessageLookupByLibrary.simpleMessage("削除"),
        "remove_arc_hax_id1_removal_failure": MessageLookupByLibrary.simpleMessage(
            "ChromeOS Android 実装のバグにより、改造用のID1 を自動的に削除できませんでした。\nもう一度お試しください。\nそれでも削除できない場合は、手動で削除する必要があります。"),
        "remove_loading":
            MessageLookupByLibrary.simpleMessage("MEST9を削除する ..."),
        "sd_setup_loading":
            MessageLookupByLibrary.simpleMessage("SDカードを設定しています..."),
        "setup_alert_disclaimer": MessageLookupByLibrary.simpleMessage(
            "3DSのデータを一時的にリセットします。\nゲームやテーマが表示されなくなりますが、完了すると元にもどります。\n\nSDカードの内容をPCなどにバックアップすることをおすすめします。\n(特にNintendo 3DSフォルダ)"),
        "setup_alert_disclaimer_confirm_to_continue":
            MessageLookupByLibrary.simpleMessage("続けるには、「確認」を押してください。"),
        "setup_alert_disclaimer_linux_addition":
            MessageLookupByLibrary.simpleMessage(
                "(Linux では、うまくいかないことがあります。SD カードを \'utf8\' オプションでマウントしてみてください。)"),
        "setup_alert_disclaimer_title":
            MessageLookupByLibrary.simpleMessage("免責事項"),
        "setup_alert_disclaimer_web_addition":
            MessageLookupByLibrary.simpleMessage(
                "(Web APIの制限があるため、データが壊れるリスクが少しだけ高くなります。バックアップを取ることを特におすすめします。)"),
        "setup_alert_dummy_db_corrupted":
            MessageLookupByLibrary.simpleMessage("タイトルデータベースが壊れている可能性があります。"),
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
                "SDカードを3DSに入れて、電源をONにしてください。\nMiiスタジオを開いてからHOMEボタンを押し、次に本体設定を開いてください。\nデータ管理→Nintendo 3DS→ソフトウェア→リセット の順に進んでください。"),
        "setup_alert_extdata_home_menu":
            MessageLookupByLibrary.simpleMessage("ホームメニューのデータがありません"),
        "setup_alert_extdata_mii_maker":
            MessageLookupByLibrary.simpleMessage("Miiメーカーのデータがありません"),
        "setup_alert_extdata_missing":
            MessageLookupByLibrary.simpleMessage("追加データがありません"),
        "setup_alert_extdata_subtitle":
            MessageLookupByLibrary.simpleMessage("追加データ"),
        "setup_alert_hax_id1_created":
            MessageLookupByLibrary.simpleMessage("改造用のID1を作成できました。"),
        "setup_alert_hax_id1_created_title":
            MessageLookupByLibrary.simpleMessage("ID1作成完了"),
        "setup_alert_multiple_id1":
            MessageLookupByLibrary.simpleMessage("複数のID1フォルダがあります。確認してください。"),
        "setup_alert_no_hax_available":
            MessageLookupByLibrary.simpleMessage("あなたの本体のバージョンには対応していません"),
        "setup_alert_no_hax_available_subtitle":
            MessageLookupByLibrary.simpleMessage("非対応バージョン"),
        "setup_alert_no_id1": MessageLookupByLibrary.simpleMessage(
            "このNintendo 3DSフォルダは使えません。ID1フォルダが入っていません。"),
        "setup_alert_repick_variant_prompt":
            MessageLookupByLibrary.simpleMessage("別の機種/バージョンを選択します。"),
        "setup_alert_sd_setup_action_setup":
            MessageLookupByLibrary.simpleMessage("セットアップ実行"),
        "setup_alert_sd_setup_failed":
            MessageLookupByLibrary.simpleMessage("SDルートを自動設定できませんでした!"),
        "setup_alert_sd_setup_file_missing":
            MessageLookupByLibrary.simpleMessage("SDカードのルートにこのファイルがありません:"),
        "setup_alert_sd_setup_file_state_missing":
            MessageLookupByLibrary.simpleMessage("不足"),
        "setup_alert_sd_setup_file_state_optional":
            MessageLookupByLibrary.simpleMessage("オプション"),
        "setup_alert_sd_setup_file_state_outdated":
            MessageLookupByLibrary.simpleMessage("古い"),
        "setup_alert_sd_setup_file_state_required":
            MessageLookupByLibrary.simpleMessage("必須"),
        "setup_alert_sd_setup_file_state_unknown_corrupted":
            MessageLookupByLibrary.simpleMessage("破損/不明"),
        "setup_alert_sd_setup_optional_prompt":
            MessageLookupByLibrary.simpleMessage(
                "壊れているファイル、不明なファイル、重要ではないファイルを自動で再ダウンロードしますか?\n(続けると、関連するすべてのファイルが自動で上書きされます。)"),
        "setup_alert_stage_name":
            MessageLookupByLibrary.simpleMessage("セットアップ"),
        "setup_loading":
            MessageLookupByLibrary.simpleMessage("MEST9をセットアップする ..."),
        "title_variant_selector":
            MessageLookupByLibrary.simpleMessage("機種とバージョンの選択"),
        "variant_selector_model_new":
            MessageLookupByLibrary.simpleMessage("New 3DS/2DS"),
        "variant_selector_model_old":
            MessageLookupByLibrary.simpleMessage("Old 3DS/2DS"),
        "variant_selector_version":
            MessageLookupByLibrary.simpleMessage("システムバージョンを選択してください:")
      };
}
