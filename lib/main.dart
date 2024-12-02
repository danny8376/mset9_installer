import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
//import 'package:fwfh_url_launcher/fwfh_url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import 'generated/l10n.dart';
import 'console.dart';
import 'hax_installer.dart';
import 'io.dart';
import 'locale_dropdown_menu.dart';
import 'root_check.dart';
import 'talker.dart';

enum Menu { credit, locale, toggleTheme, advance, extra, looseRootCheck, legacyCode, log }
enum AlertType { error, warning, info, confirm }
enum AlertStage { folder, setup, remove }

void main() async {
  if (isDesktop) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
  }
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => SettingsProvider(),
      ),
    ], child: const MyApp()),
  );
}

class SettingsProvider with ChangeNotifier, WidgetsBindingObserver {
  Locale _locale = S.delegate.supportedLocales.first;
  bool _localeForced = false;

  bool _darkMode = true;
  bool _darkModeForced = false;

  Locale get locale => _locale;
  set locale(Locale? newLocale) {
    if (newLocale == null) {
      _localeForced = false;
      updateLocale();
      return;
    }
    if (!S.delegate.supportedLocales.contains(newLocale)) {
      throw Exception("Unsupported Locale");
    }
    _locale = newLocale;
    _localeForced = true;
    notifyListeners();
  }

  bool get darkMode => _darkMode;
  ThemeMode get themeMode => _darkMode ? ThemeMode.dark : ThemeMode.light;

  SettingsProvider() {
    updateLocale();
    updateModeFromSystem();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (_localeForced) {
      return;
    }
    updateLocale(locales);
  }

  void updateLocale([List<Locale>? locales]) {
    locales ??= kDebugMode
      ? [S.delegate.supportedLocales.first]
      : PlatformDispatcher.instance.locales;
    for (final locale in locales) {
      if (S.delegate.supportedLocales.contains(locale)) {
        _locale = locale;
        break;
      }
    }
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    updateModeFromSystem();
  }

  void updateModeFromSystem() => toggleTheme(true);

  void toggleTheme([bool systemBrightness = false]) {
    if (systemBrightness) {
      if (_darkModeForced) {
        return;
      }
      final systemDarkMode = PlatformDispatcher.instance.platformBrightness == Brightness.dark;
      if (_darkMode == systemDarkMode) {
        return;
      }
      _darkMode = systemDarkMode;
    } else {
      _darkModeForced = true;
      _darkMode = !_darkMode;
    }
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: Provider.of<SettingsProvider>(context).themeMode,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: Provider.of<SettingsProvider>(context).locale,
      home: const Installer(),
      onGenerateTitle: (context) {
        final title = S.of(context).app_name;
        if (isDesktop) {
          windowManager.setTitle(title);
        }
        return title;
      },
    );
  }
}

class Installer extends StatefulWidget {
  const Installer({super.key});

  @override
  State<Installer> createState() => _InstallerState();
}

class _InstallerState extends State<Installer> {
  bool _advance = false;

  //bool _showingLoading = false;
  //Timer? _preLoadingTimer;
  bool _disclaimerShown = false;

  late final HaxInstaller installer;

  S _s() {
    if (!context.mounted) {
      throw Exception("S called outside of context!");
    }
    return S.of(context);
  }

  SettingsProvider? _settings;
  SettingsProvider get settings {
    if (_settings == null) {
      throw Exception("Try to access theme provider before build ever run somehow!");
    }
    return _settings!;
  }

  Widget _buildAlertButton(BuildContext context, String text, void Function(void Function())? action) {
    pop() {
      Navigator.of(context).pop();
    }
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: () => (action ?? (f) => f())(pop),
      child: Text(text),
    );
  }

  List<Widget> _buildAlertTroubleshootingButtonsFunc(BuildContext context, [String? link]) {
    return <Widget>[
      _buildAlertButton(context, _s().alert_action_troubleshooting, (pop) {
        launchUrl(Uri.parse(link ?? _s().alert_general_troubleshooting_url));
      }),
      //const Spacer(),
      _buildAlertButton(context, _s().alert_neutral, null),
    ];
  }

  List<Widget> _buildAlertVisualAidButtonsFunc(BuildContext context) {
    return <Widget>[
      _buildAlertButton(context, _s().setup_alert_dummy_db_visual_aid, (pop) {
        launchUrl(Uri.parse(_s().setup_alert_dummy_db_visual_aid_url));
      }),
      _buildAlertButton(context, _s().alert_action_troubleshooting, (pop) {
        launchUrl(Uri.parse(_s().alert_general_troubleshooting_url));
      }),
      //const Spacer(),
      _buildAlertButton(context, _s().alert_neutral, null),
    ];
  }

  Future<void> _showAlert(String message, {
    BuildContext? context,
    String? title,
    String? subtitle,
    AlertStage? stage,
    AlertType? type,
    String? no,
    double? titleFontSize,
    bool dismissible = true,
    List<Widget> Function(BuildContext)? buttonBuilder,
  }) async {
    // required or this will break when showLoading
    await Future.delayed(Duration.zero);
    context ??= this.context;
    if (!context.mounted) {
      throw Exception("context somehow get unmounted!");
    }
    Widget? genTitleWidget() {
      var localTitle = title;
      localTitle ??= switch (type) {
        AlertType.error => _s().alert_error_title,
        AlertType.warning => _s().alert_warning_title,
        AlertType.info => _s().alert_info_title,
        AlertType.confirm => _s().alert_confirm_title,
        null => null,
      };
      if (localTitle == null) {
        return null;
      }
      var squashStage = false;
      if (localTitle.endsWith("\$")) {
        squashStage = true;
        localTitle = localTitle.substring(0, localTitle.length - 1);
      }
      const iconSize = 34.0;
      const mainFontWeight = FontWeight.w900;
      final mainTitleTextWidget = Text(
        no == null ? localTitle : "$localTitle #$no",
        style: titleFontSize == null ? const TextStyle(
          fontSize: 24.0,
          fontWeight: mainFontWeight,
        ) : TextStyle(
          fontSize: titleFontSize,
          fontWeight: mainFontWeight,
        ),
      );
      final icon = switch ((type, settings.darkMode)) {
        (AlertType.error, true /* dark */) => const Icon(
          Icons.error_sharp,
          size: iconSize,
          color: Colors.redAccent,
        ),
        (AlertType.error, false /* light */) => const Icon(
          Icons.error_sharp,
          size: iconSize,
          color: Colors.red,
        ),
        (AlertType.warning, true /* dark */) => const Icon(
          Icons.warning_amber_outlined,
          size: iconSize,
          color: Colors.amberAccent,
        ),
        (AlertType.warning, false /* light */) => const Icon(
          Icons.warning_amber_outlined,
          size: iconSize,
          color: Colors.amber,
        ),
        (AlertType.info, true /* dark */) => const Icon(
          Icons.info_outline,
          size: iconSize,
          color: Colors.blueGrey,
        ),
        (AlertType.info, false /* light */) => const Icon(
          Icons.info_outline,
          size: iconSize,
          color: Colors.lightBlueAccent,
        ),
        (AlertType.confirm, true /* dark */) => const Icon(
          Icons.question_mark,
          size: iconSize,
          color: Colors.blueGrey,
        ),
        (AlertType.confirm, false /* light */) => const Icon(
          Icons.question_mark,
          size: iconSize,
          color: Colors.lightBlueAccent,
        ),
        (null, _) => null,
      };
      final titleTextsWidget = subtitle == null ? mainTitleTextWidget : Column(
        children: [
          mainTitleTextWidget,
          const Padding(padding: EdgeInsets.all(2.0)),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
      if (icon == null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [titleTextsWidget],
        );
      }
      Widget genStage(String text, IconData icon) {
        const style = TextStyle(
          fontSize: 12.0,
          color: Colors.grey,
        );
        final (width, widget) = (squashStage || text == "@")
          ? (28.0, Icon(icon, size: style.fontSize, color: style.color))
          : (iconSize, Text(text, style: style));
        return SizedOverflowBox(
          size: Size(width, iconSize),
          alignment: AlignmentDirectional.centerEnd,
          child: widget,
        );
      }
      final stageWidget = switch (stage) {
        AlertStage.folder => genStage(_s().pick_alert_stage_name, Icons.folder_open_outlined),
        AlertStage.setup => genStage(_s().setup_alert_stage_name, Icons.build_circle_outlined),
        AlertStage.remove => genStage(_s().remove_alert_stage_name, Icons.delete_outlined),
        null => const SizedBox(width: 10.0),
      };
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon,
          titleTextsWidget,
          stageWidget,
        ],
      );
    }
    buttonBuilder ??= (BuildContext dialogContext) => dismissible ? <Widget>[
      _buildAlertButton(dialogContext, _s().alert_neutral, null),
    ] : <Widget>[];
    await showDialog<void>(
      context: context,
      barrierDismissible: dismissible,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: genTitleWidget(),
          content: Text(message),
          actions: buttonBuilder!(dialogContext),
        );
      },
    );
  }

  Future<void> _showLoading(BuildContext? context, String text) async {
    /*
    if (_showingLoading) {
      return;
    }
    _preLoadingTimer?.cancel();
    _preLoadingTimer = null;
     */
    context ??= this.context;
    if (!context.mounted) {
      throw Exception("_showLoading called outside of context!");
    }
    //_showingLoading = true;
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(
                    color: Theme.of(context).indicatorColor,
                    strokeWidth: 7,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.none
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCredit([BuildContext? context]) async {
    late final String mdTpl;
    try {
      final locale = Intl.getCurrentLocale();
      mdTpl = await rootBundle.loadString("assets/credit/$locale.md");
    } catch (_) {
      mdTpl = await rootBundle.loadString("assets/credit/en.md");
    }
    final info = await PackageInfo.fromPlatform();
    final md = mdTpl.replaceAllMapped(RegExp(
      r'{{(?<varName>[^}]+)}}|(?<comment><!--) .*? -->|<(?<comment2>translatable-comment)>.*?</translatable-comment>'
    ), (match) {
      if (match is! RegExpMatch) {
        return match.toString();
      }
      final comment = match.namedGroup("comment") ?? match.namedGroup("comment2");
      if (comment != null) {
        return "";
      }
      final varName = match.namedGroup('varName');
      return switch (varName) {
        "APP_NAME" => _s().app_name,
        "APP_VER" => info.version,
        _ => "{{$varName}}",
      };
    });
    final mdConfig = settings.darkMode
      ? MarkdownConfig.darkConfig.copy(
        configs: [
          const LinkConfig(
            style: TextStyle(
              color: Colors.lightBlueAccent,
              decoration: TextDecoration.underline,
              decorationColor: Colors.lightBlueAccent,
            ),
          ),
        ],
      )
      : MarkdownConfig.defaultConfig.copy(
        configs: [
          const LinkConfig(
            style: TextStyle(
              color: Colors.indigo,
              decoration: TextDecoration.underline,
              decorationColor: Colors.indigo,
            ),
          ),
        ],
      );
    context ??= this.context;
    if (!context.mounted) {
      throw Exception("context somehow get unmounted!");
    }
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(_s().menu_credit),
          //content: HtmlWidget(html, factoryBuilder: () => HtmlWidgetWithUrlLauncherFactory()),
          content: SingleChildScrollView(
            child: MarkdownBlock(
              data: md,
              config: mdConfig,
            ),
          ),
          actions: <Widget>[
            _buildAlertButton(dialogContext, _s().alert_neutral, null),
          ],
        );
      },
    );
  }

  Future<void> _showLocaleSelection([BuildContext? context]) async {
    context ??= this.context;
    if (!context.mounted) {
      throw Exception("context somehow get unmounted!");
    }
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(_s().menu_alert_language_title),
        content: LayoutBuilder(
          builder: (_, constraints) => LocaleDropdownMenu.fromSupportedLocales(
            width: constraints.constrainWidth(),
            initialSelection: settings.locale,
            onSelected: (Locale? locale) {
              if (locale == null) {
                return;
              }
              settings.locale = locale;
            },
          ),
        ),
        actions: <Widget>[
          _buildAlertButton(dialogContext, _s().menu_alert_language_action, null),
        ],
      ),
    );
  }

  Future<void> _dismissLoading([BuildContext? context]) async {
    /*
    if (!_showingLoading) {
      return;
    }
     */
    context ??= this.context;
    if (!context.mounted) {
      throw Exception("_dismissLoading called outside of context!");
    }
    Navigator.of(context).pop();
    //_showingLoading = false;
  }

  void _pickFolder() async {
    var dir = await pickFolder();
    if (dir == null) {
      return;
    }
    try {
      await installer.checkAndAssignFolders(dir);
    } on FolderAssignmentException catch (e) {
      _handleAlert(e.type, additionalInfo: e.count,
        alertTypeOverride: AlertType.error, stageOverride: AlertStage.folder);
    }
  }

  Future<Variant?> _pickVariant() => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => VariantSelector(extra: installer.extraVersions)),
  );

  Future<bool> _showDisclaimer() async {
    if (_advance && _disclaimerShown) {
      return true;
    }
    var confirm = false;
    var disclaimer = _s().setup_alert_disclaimer;
    if (isLinux) disclaimer += "\n\n${_s().setup_alert_disclaimer_linux_addition}";
    if (kIsWeb) disclaimer += "\n\n${_s().setup_alert_disclaimer_web_addition}";
    disclaimer += "\n\n${_s().setup_alert_disclaimer_confirm_to_continue}";
    await _showAlert(
      disclaimer,
      title: _s().setup_alert_disclaimer_title,
      buttonBuilder:  (context) => <Widget>[
        _buildAlertButton(context, _s().alert_general_cancel, null),
        _buildAlertButton(context, _s().alert_general_confirm, (pop) {
          pop();
          confirm = true;
        }),
      ],
    );
    _disclaimerShown = true;
    return confirm;
  }

  void _doSetup() async {
    if (!await _showDisclaimer()) {
      return;
    }

    final variant = await _pickVariant();
    if (variant == null) {
      return;
    }
    installer.switchVariant(variant);
    _doWorkWrap(
      loading: _s().setup_loading,
      work: installer.setupHaxId1,
      done: (result) async {
        if (result) {
          _showAlert(
            "${_s().setup_alert_hax_id1_created}\n\n${_s().setup_alert_dummy_mii_maker_and_db_reset}",
            type: AlertType.info,
            title: _s().setup_alert_hax_id1_created_title,
            titleFontSize: 16.0,
            buttonBuilder: _buildAlertVisualAidButtonsFunc,
          );
        }
      },
    );
  }

  void _doRepickVariant() async {
    if (installer.id1HaxFolder == null) {
      return;
    }
    final variant = await _pickVariant();
    if (variant == null || variant == installer.variant) {
      talker.debug("Setup: Repick Variant - Cancelled / Same Variant Picked");
      return;
    }
    _doWorkWrap(
      loading: _s().setup_loading,
      work: () => installer.switchVariant(variant),
      done: (result) async {
        installer.checkInjectState(silent: true);
      },
    );
  }

  void _doInjectTrigger() => _doWorkWrap(
    loading: null, // this is usually fast enough?
    work: installer.injectTrigger,
  );

  void _doRemoveTrigger() => _doWorkWrap(
    loading: null, // this is usually fast enough?
    work: installer.removeTrigger,
  );

  void _doRemove() async {
    if (!_advance && !await installer.checkIfCfwInstalled()) {
      var cancel = true;
      await _showAlert(
          _s().remove_alert_confirm,
          type: AlertType.confirm,
          stage: AlertStage.remove,
          buttonBuilder: (context) => <Widget>[
            _buildAlertButton(context, _s().remove_alert_action_repick, (pop) {
              pop();
              _doRepickVariant();
            }),
            //const Spacer(),
            _buildAlertButton(context, _s().alert_general_cancel, null),
            _buildAlertButton(context, _s().alert_general_confirm, (pop) {
              pop();
              cancel = false;
            }),
          ]
      );
      if (cancel) {
        return;
      }
    }

    _doWorkWrap(
      loading: _s().remove_loading,
      work: installer.removeHaxId1,
    );
  }

  Future<bool> _doWorkWrap({
    String? loading,
    required Future<bool> Function() work,
    Future<void> Function(bool result)? done,
  }) async {
    if (loading != null) {
      _showLoading(null, loading);
    }
    bool result = false;
    try {
      result = await work();
    } catch (e, st) {
      talker.handle(e, st);
    }
    if (loading != null && context.mounted) {
      _dismissLoading();
    }
    if (done != null) {
      await done(result);
    }
    return result;
  }

  Widget _genButton(BuildContext context, List<HaxStage>? stages, Function()? action, String text, {Function()? extraAction}) {
    const double margin = 8;
    final mainButton = FilledButton(
      onPressed: (stages != null && (stages.isEmpty || stages.contains(installer.stage))) ? action : null,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(64),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return Container(
        margin: const EdgeInsets.fromLTRB(margin, 0, margin, margin),
        child: extraAction == null ? mainButton : Stack(
          alignment: Alignment.center,
          children: [
            mainButton,
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: extraAction,
                icon: const Icon(Icons.more_vert),
                color: Theme.of(context).secondaryHeaderColor,
              ),
            )
          ],
        )
    );
  }

  void _stageUpdate(HaxStage stage) async {
    //_preLoadingTimer?.cancel();
    //_preLoadingTimer = null;
    talker.debug("Installer: stage updated to $stage");
    await Future.delayed(Duration.zero);
    setState(() {
    });
    /*
    if (stage == HaxStage.doingWork && !_showingLoading) {
      _preLoadingTimer = Timer(const Duration(milliseconds: 250), () {
        _showLoading(null, installer.workIsCheck ? _s().check_loading : _s().setup_loading);
      });
    }
    if (stage != HaxStage.doingWork && _showingLoading) {
      _dismissLoading();
    }
     */
  }

  void _handleConfirmation(HaxConfirmationType confirmationType, Future<bool> Function(bool) confirm, [dynamic extraData]) async {
    switch (confirmationType) {
      case HaxConfirmationType.autoSdRootSetup:
        final missing = extraData as Map<String, CheckState>;
        final optionalOnly = missing.entries.every((e) => e.value.optional);
        final list = missing.entries.map<String>((entry) {
          final state = switch (entry.value.state) {
            CheckStateState.missing => _s().setup_alert_sd_setup_file_state_missing,
            CheckStateState.outdated => _s().setup_alert_sd_setup_file_state_outdated,
            CheckStateState.unknownOrCorrupted => _s().setup_alert_sd_setup_file_state_unknown_corrupted,
          };
          final suffix = installer.looseRootCheck
            ? (entry.value.optional ? "" : " (${_s().setup_alert_sd_setup_file_state_required})")
            : (entry.value.optional ? " (${_s().setup_alert_sd_setup_file_state_optional})" : "");
          return "${entry.key}: $state$suffix";
        }).sorted((a, b) => a.toUpperCase().compareTo(b.toUpperCase())).join("\n");
        var doSDSetup = false;
        await _showAlert(
            "${_s().setup_alert_sd_setup_file_missing}\n\n$list",
            type: optionalOnly ? AlertType.warning : AlertType.error,
            stage: AlertStage.setup,
            buttonBuilder: (context) => <Widget>[
              _buildAlertButton(context, _s().setup_alert_sd_setup_action_setup, (pop) {
                pop();
                doSDSetup = true;
              }),
              //const Spacer(),
              _buildAlertButton(context, _s().alert_neutral, null),
            ]
        );
        if (doSDSetup) {
          _doWorkWrap(
            loading: _s().sd_setup_loading,
            work: () => confirm(true),
            done: (result) async {}
          );
        } else {
          confirm(false);
        }
      case HaxConfirmationType.sdRootSetupIncludeCorruptedUnknownOptional:
        var getOptional = false;
        await _showAlert(
          _s().setup_alert_sd_setup_optional_prompt,
          type: AlertType.confirm,
          stage: AlertStage.setup,
          buttonBuilder: (context) => <Widget>[
            _buildAlertButton(context, _s().alert_general_no, null),
            _buildAlertButton(context, _s().alert_general_yes, (pop) {
              pop();
              getOptional = true;
            }),
          ],
        );
        confirm(getOptional);
    }
  }

  void _handleAlert(HaxAlertType haxAlertType, {dynamic additionalInfo, AlertType? alertTypeOverride, AlertStage? stageOverride}) {
    const error = AlertType.error;
    //final type = alertTypeOverride ?? error;
    final stage = stageOverride ?? AlertStage.setup;
    final troubleshooting = _buildAlertTroubleshootingButtonsFunc;
    final visualAid = _buildAlertVisualAidButtonsFunc;
    final dummyDb = _s().setup_alert_dummy_db_subtitle;
    final extdata = _s().setup_alert_extdata_subtitle;
    switch (haxAlertType) {
      case HaxAlertType.noN3DS:
        _showAlert("${_s().pick_no_n3ds}\n${_s().pick_common_n3ds_info}", type: error, stage: stage, buttonBuilder: troubleshooting, no: "01");
      case HaxAlertType.noId0:
        _showAlert("${_s().pick_no_id0}\n${_s().pick_common_n3ds_info}", type: error, stage: stage, buttonBuilder: troubleshooting, no: "01");
      case HaxAlertType.multipleId0:
        _showAlert(_s().pick_multiple_id0, type: error, stage: stage, buttonBuilder: troubleshooting, no: "04");
      case HaxAlertType.noId1:
        // is this really the appropriate error no?
        // but other failed midway error shouldn't go here unless everything inside id0 is gone
        _showAlert(_s().setup_alert_no_id1, type: error, stage: stage, buttonBuilder: troubleshooting, no: "01");
      case HaxAlertType.multipleId1:
        _showAlert(_s().setup_alert_multiple_id1, type: error, stage: stage, buttonBuilder: troubleshooting, no: "05");
      case HaxAlertType.id1Picked:
        _showAlert(_s().pick_picked_id1, type: error, stage: stage, buttonBuilder: troubleshooting);
      case HaxAlertType.unknownFolderPicked:
        _showAlert(_s().pick_picked_unknown, type: error, stage: stage);
      case HaxAlertType.brokenId0Contents:
        _showAlert(_s().pick_broken_id0_contents, type: error, stage: stage);
      case HaxAlertType.noHaxAvailable:
        _showAlert(_s().setup_alert_no_hax_available, type: error, stage: stage, subtitle: _s().setup_alert_no_hax_available_subtitle);
      case HaxAlertType.multipleHaxId1:
        break;
      case HaxAlertType.sdSetupFailed:
        _showAlert(_s().setup_alert_sd_setup_failed, type: error, stage: stage);
      case HaxAlertType.dummyDb:
        _showAlert("${_s().setup_alert_dummy_db_found}\n\n${_s().setup_alert_dummy_db_reset}", type: error, stage: stage, subtitle: dummyDb, buttonBuilder: visualAid);
      case HaxAlertType.corruptedDb:
        _showAlert("${_s().setup_alert_dummy_db_corrupted}\n\n${_s().setup_alert_dummy_db_reset}", type: error, stage: stage, subtitle: dummyDb, buttonBuilder: visualAid);
      case HaxAlertType.extdataFolderMissing:
        _showAlert(_s().setup_alert_extdata_missing, type: error, stage: stage, subtitle: extdata, buttonBuilder: troubleshooting);
      case HaxAlertType.homeMenuExtdataMissing:
        _showAlert(_s().setup_alert_extdata_home_menu, type: error, stage: stage, subtitle: extdata, buttonBuilder: troubleshooting);
      case HaxAlertType.miiMakerExtdataMissing:
        _showAlert(_s().setup_alert_extdata_mii_maker, type: error, stage: stage, subtitle: extdata, buttonBuilder: troubleshooting);
    }
  }

  @override
  void initState() {
    super.initState();
    if (!isSupported) {
      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        _showAlert(
          _s().alert_not_supported,
          type: AlertType.error,
          title: _s().alert_not_supported_title,
          dismissible: false,
        );
      });
    }
    if (kDebugMode) {
      _advance = true;
    }
    installer = HaxInstaller(
      stageUpdateCallback: _stageUpdate,
      alertCallback: _handleAlert,
      confirmationCallback: _handleConfirmation,
    );
  }

  @override
  Widget build(BuildContext context) {
    // we don't need to listen as parent widget (MyApp) will handle all rebuild
    _settings ??= Provider.of<SettingsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(S.of(context).app_name),
        actions: <Widget>[
          PopupMenuButton<Menu>(
            icon: const Icon(Icons.more_vert),
            constraints: const BoxConstraints(
              minWidth: 3.5 * 56.0, // no sure why it's stuck to min...
              maxWidth: 5.0 * 56.0,
            ),
            onSelected: (Menu item) {
              switch (item) {
                case Menu.credit:
                  _showCredit(context);
                case Menu.locale:
                  _showLocaleSelection(context);
                case Menu.toggleTheme:
                  settings.toggleTheme();
                case Menu.advance:
                case Menu.extra:
                case Menu.looseRootCheck:
                case Menu.legacyCode:
                  break; // Checkboxes are handled in their own events
                case Menu.log:
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TalkerScreen(talker: talker),
                      )
                  );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              PopupMenuItem<Menu>(
                value: Menu.credit,
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(_s().menu_credit),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<Menu>(
                value: Menu.locale,
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(_s().menu_language),
                ),
              ),
              PopupMenuItem<Menu>(
                value: Menu.toggleTheme,
                child: settings.darkMode ? ListTile(
                  leading: const Icon(Icons.light_mode),
                  title: Text(_s().menu_force_light_mode),
                ) : ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: Text(_s().menu_force_dark_mode),
                ),
              ),
              PopupMenuItem<Menu>(
                value: Menu.advance,
                child: CheckboxListTile(
                  title: Text(_s().menu_advance),
                  value: _advance,
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    _advance = !_advance;
                  },
                ),
              ),
              ...(_advance ? [
                const PopupMenuDivider(),
                PopupMenuItem<Menu>(
                  value: Menu.extra,
                  child: StatefulBuilder(
                    builder: (subContext, subSetState) =>
                        CheckboxListTile(
                          title: Text(_s().menu_extra),
                          value: installer.extraVersions,
                          onChanged: (bool? value) {
                            subSetState(() {
                              installer.extraVersions = !installer.extraVersions;
                            });
                          },
                        ),
                  ),
                ),
                PopupMenuItem<Menu>(
                  value: Menu.looseRootCheck,
                  child: StatefulBuilder(
                    builder: (subContext, subSetState) =>
                        CheckboxListTile(
                          title: Text(_s().menu_loose_root_check),
                          value: installer.looseRootCheck,
                          onChanged: (bool? value) {
                            subSetState(() {
                              installer.looseRootCheck = !installer.looseRootCheck;
                            });
                          },
                        ),
                  ),
                ),
                ...(isLegacyCodeCompatible ? [PopupMenuItem<Menu>(
                  value: Menu.legacyCode,
                  child: StatefulBuilder(
                    builder: (subContext, subSetState) =>
                        CheckboxListTile(
                          title: Text(_s().menu_legacy),
                          value: installer.legacyCode,
                          onChanged: (bool? value) {
                            subSetState(() {
                              installer.legacyCode = !installer.legacyCode;
                            });
                          },
                        ),
                  ),
                )] : []),
              ] : []),
              const PopupMenuDivider(),
              PopupMenuItem<Menu>(
                value: Menu.log,
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(_s().menu_log),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _genButton(
            context,
            const [
              HaxStage.pickFolder, HaxStage.folderPicked, HaxStage.folderPickedWithError,
              HaxStage.cardRemoved, HaxStage.postSetup,
              HaxStage.readyToInject, HaxStage.doExploit, HaxStage.broken
            ],
            _pickFolder,
            showPickN3DS ? S.of(context).installer_button_pick_3ds : S.of(context).installer_button_pick_sd,
          ),
          switch (installer.stage) {
            HaxStage.doingWork =>
              _genButton(context, null, null, _s().installer_button_dummy_checking),
            HaxStage.folderPickedWithError =>
              _genButton(context, const [], installer.checkState, _s().installer_button_check_sd),
            HaxStage.cardRemoved || HaxStage.postSetup || HaxStage.readyToInject || HaxStage.doExploit || HaxStage.broken =>
              _genButton(
                context,
                const [],
                installer.checkState,
                _s().installer_button_check,
                extraAction: () {
                  _showAlert(
                    _s().setup_alert_repick_variant_prompt,
                    type: AlertType.confirm,
                    stage: AlertStage.setup,
                    buttonBuilder: (context) => <Widget>[
                      _buildAlertButton(context, _s().alert_general_cancel, null),
                      _buildAlertButton(context, _s().alert_general_yes, (pop) {
                        pop();
                        _doRepickVariant();
                      }),
                    ],
                  );
                },
              ),
            _ =>
              _genButton(
                context,
                const [HaxStage.folderPicked],
                _doSetup,
                _s().installer_button_setup,
              )
          },
          _genButton(
            context,
            const [HaxStage.readyToInject],
            _doInjectTrigger,
            S.of(context).installer_button_inject_trigger,
          ),
          _genButton(
            context,
            const [HaxStage.doExploit],
            _doRemoveTrigger,
            S.of(context).installer_button_remove_trigger,
          ),
          _genButton(
            context,
            const [HaxStage.postSetup, HaxStage.readyToInject, HaxStage.doExploit, HaxStage.broken],
            _doRemove,
            S.of(context).installer_button_remove,
          ),
        ],
      ),
    );
  }
}

class VariantSelector extends StatefulWidget {
  final bool extra;

  const VariantSelector({super.key, this.extra = false});

  @override
  State<VariantSelector> createState() => _VariantSelectorState();
}

class _VariantSelectorState extends State<VariantSelector> {
  Model _model = Model.unknown;
  late int _major;
  int _minor = -1;

  @override
  void initState() {
    super.initState();
    _major = widget.extra ? -1 : 11;
  }

  void _checkReturn(BuildContext context) {
    if (_model != Model.unknown && _major != -1 && _minor != -1) {
      try {
        Navigator.pop(context, Variant(_model, ver(_major, _minor, 0)));
      } on InvalidVersionException {
        talker.error("invalid version $_major.$_minor");
      }
    }
  }

  BoxDecoration _modelBoxDecoration(Model model) {
    return BoxDecoration(
      color: _model == model ? Colors.primaries.last : null,
      borderRadius: BorderRadius.circular(10),
    );
  }

  double _maxImageButtonSize(BuildContext context) {
    return [
      MediaQuery.of(context).size.width / 2,
      (MediaQuery.of(context).size.height - 172) / 3,
    ].reduce(min).floorToDouble();
  }

  Widget _genModelText(BuildContext context, String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _genButton(BuildContext context, String assetName, Model model) {
    final size = _maxImageButtonSize(context);
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        constraints: BoxConstraints(maxWidth: size, maxHeight: size),
        icon: Image(image: AssetImage(assetName)),
        onPressed: () {
          setState(() {
            _model = _model == model ? Model.unknown : model;
            _checkReturn(context);
          });
        },
      ),
    );
  }

  Widget _genDropdown(BuildContext context, int max, int Function()? value, Function(int?)? action) {
    final list = List<int>.generate(max + 2, (i) {
      return i == 0 ? -1 : max - i + 1;
    });
    return DropdownButton<int>(
      value: value?.call() ?? 0,
      //icon: const Icon(Icons.arrow_upward_rounded),
      onChanged: action == null ? null : ((val) {
        action(val);
        _checkReturn(context);
      }),
      itemHeight: kMinInteractiveDimension,
      menuMaxHeight: isMobile ? 480 : null,
      items: list.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value < 0 ? "" : value.toString().padLeft(2, ' '),
            style: const TextStyle(
              fontSize: 32,
              //fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(S.of(context).title_variant_selector),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: _modelBoxDecoration(Model.oldModel),
                child: Column(
                  children: [
                    _genModelText(context, S.of(context).variant_selector_model_old),
                    _genButton(
                      context,
                      "assets/images/old3ds.png",
                      Model.oldModel,
                    ),
                    _genButton(
                      context,
                      "assets/images/old3dsxl.png",
                      Model.oldModel,
                    ),
                    _genButton(
                      context,
                      "assets/images/old2ds.png",
                      Model.oldModel,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: _modelBoxDecoration(Model.newModel),
                child: Column(
                  children: [
                    _genModelText(context, S.of(context).variant_selector_model_new),
                    _genButton(
                      context,
                      "assets/images/new3ds.png",
                      Model.newModel,
                    ),
                    _genButton(
                      context,
                      "assets/images/new3dsxl.png",
                      Model.newModel,
                    ),
                    _genButton(
                      context,
                      "assets/images/new2dsxl.png",
                      Model.newModel,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(S.of(context).variant_selector_version),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _genDropdown(context, 11, () => _major, widget.extra ? (val) {
                setState(() {
                  _major = val ?? -1;
                });
              } : null),
              const Text("."),
              _genDropdown(context, 17, () => _minor, (val) {
                setState(() {
                  _minor = val ?? -1;
                });
              }),
              const Text("."),
              _genDropdown(context, 0, null, null),
            ],
          ),
        ],
      ),
    );
  }
}

/*
class HtmlWidgetWithUrlLauncherFactory extends WidgetFactory with UrlLauncherFactory {
}
 */
