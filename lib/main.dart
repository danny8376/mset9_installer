import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';
import 'console.dart';
import 'consts.dart';
import 'hax.dart';
import 'string_utils.dart';
import 'io.dart';
import 'utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MSET9 Installer",
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const Installer(),
    );
  }
}

class Installer extends StatefulWidget {
  const Installer({super.key});

  @override
  State<Installer> createState() => _InstallerState();
}

class _InstallerState extends State<Installer> {
  Stage _stage = Stage.pick;

  Directory? sdRoot;
  Directory? n3dsFolder;
  Directory? id0Folder;
  Variant? variant;

  Directory? id1Folder;
  Directory? id1HaxFolder;
  Directory? id1HaxExtdataFolder;

  S _s() {
    if (!context.mounted) {
      throw Exception("S called outside of context!");
    }
    return S.of(context);
  }

  Widget _buildAlertButton(BuildContext context, String text, Function() action) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: action,
      child: Text(text),
    );
  }

  List<Widget> _buildAlertVisualAidButtonsFunc(context) {
    return <Widget>[
      _buildAlertButton(context, _s().setup_alert_dummy_db_visual_aid, () {
        launchUrl(Uri.parse(_s().setup_alert_dummy_db_visual_aid_url));
      }),
      //const Spacer(),
      _buildAlertButton(context, _s().alert_neutral, () {
        Navigator.of(context).pop();
      }),
    ];
  }

  Future<void> _showAlert(BuildContext? context, String title, String message, [List<Widget> Function(BuildContext)? buttonBuilder]) {
    context ??= this.context;
    if (!context.mounted) {
      throw Exception("S called outside of context!");
    }
    final actions = buttonBuilder?.call(context) ?? <Widget>[
      _buildAlertButton(context, S.of(context).alert_neutral, () {
        if (context?.mounted == true) {
          Navigator.of(context!).pop();
        }
      }),
    ];
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: actions,
        );
      },
    );
  }

  Future<void> _showLoading(BuildContext? context, String text) {
    context ??= this.context;
    if (!context.mounted) {
      throw Exception("_showLoading called outside of context!");
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CircularProgressIndicator(
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
                      fontWeight: FontWeight.bold,
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

  void _checkState() async {
    logger.d("Common: checking state");
    if (id0Folder != null) {
      final matching = await _findMatchingHaxId1();
      if (matching != null) {
        id1HaxFolder = matching.folder;
        variant = matching.hax.dummyVariant;
        _checkInjectState();
      } else if ((await _findId1() && await _findBackupId1() != null) || (await _findId1() && await _findMatchingHaxId1() != null)) {
        setState(() {
          _stage = Stage.broken;
        });
      } else if (_stage == Stage.variant && variant != null) {
        _doSetup();
      } else {
        setState(() {
          _stage = Stage.setup;
        });
      }
    } else {
      setState(() {
        _stage = Stage.pick;
      });
    }
  }

  void _checkInjectState() async {
    logger.d("Common: checking inject state");
    if (id1HaxFolder == null) {
      return;
    }
    if (await _checkIfDummyDbs()) {
      logger.i("Check: hax id1 dbs is missing/dummy");
      //showSnackbar(_s().inject_missing_hax_extdata);
      setState(() {
        _stage = Stage.postSetup;
      });
      return;
    }
    id1HaxExtdataFolder = (await findFileIgnoreCase(id1HaxFolder, "extdata")) as Directory?;
    if (id1HaxExtdataFolder == null) {
      logger.i("Check: hax id1 extdata folder is missing");
      await _showAlert(null, _s().setup_alert_extdata_title, _s().setup_alert_extdata_missing);
      setState(() {
        _stage = Stage.postSetup;
      });
      return;
    }
    final extdata0 = await id1HaxExtdataFolder?.directory("00000000");
    if (extdata0 == null) {
      logger.e("Check: hax id1 extdata/00000000 folder is missing!");
      await _showAlert(null, _s().setup_alert_extdata_title, _s().setup_alert_extdata_missing);
      setState(() {
        _stage = Stage.postSetup;
      });
      return;
    }
    final extdataPair = await ExtDataIdPair.findDirectory(extdata0);
    if (extdataPair == null) {
      final partialExtdataPair = await ExtDataIdPair.findDirectory(extdata0, partialMatch: true);
      if (partialExtdataPair == null) {
        logger.i("Check: No home menu extdata folder!");
        await _showAlert(null, _s().setup_alert_extdata_title, _s().setup_alert_extdata_home_menu);
      } else if (partialExtdataPair.miiMaker == null) {
        logger.i("Check: No mii maker extdata folder!");
        await _showAlert(null, _s().setup_alert_extdata_title, _s().setup_alert_extdata_mii_maker);
      } else {
        // only mii maker - WTF?
      }
      setState(() {
        _stage = Stage.postSetup;
      });
      return;
    }
    if (await findFileIgnoreCase(id1HaxExtdataFolder, kTriggerFile) == null) {
      setState(() {
        _stage = Stage.inject;
      });
    } else {
      setState(() {
        _stage = Stage.trigger;
      });
    }
  }

  void _pickFolder() async {
    final dir = await pickFolder();
    if (dir != null) {
      if (kN3dsFolder.equalsIgnoreAsciiCase(dir.name)) {
        logger.d("FolderPicking: Nintendo 3DS Folder Picked");
        n3dsFolder = dir;
        await _pickID0FromN3DS();
      } else if (await _checkIfId0(dir)) {
        logger.d("FolderPicking: ID0 Folder Picked");
        id0Folder = dir;
      } else if (await _checkIfId1(dir)) {
        logger.e("FolderPicking: ID1 Folder Picked");
        //showSnackbar(_s().pick_picked_id1, Snackbar.LENGTH_LONG)
      } else if (await _pickN3DSFromSDRoot(dir)) {
        logger.d("FolderPicking: SD Root Picked");
      } else {
        logger.e("FolderPicking: Unknown Folder Picked");
        //showSnackbar(_s().pick_picked_unknown, Snackbar.LENGTH_LONG)
      }
      _checkState();
    }
  }

  Future<bool> _pickN3DSFromSDRoot(Directory folder) async {
    final sub = await findFileIgnoreCase(folder, kN3dsFolder);
    if (sub != null && await FileSystemUtils.isDirectory(sub)) {
      sdRoot = folder;
      n3dsFolder = sub as Directory;
      await _pickID0FromN3DS();
      return true;
    }
    return false;
  }

  Future<bool> _pickID0FromN3DS([Directory? folder]) {
    folder ??= n3dsFolder;
    return findJustOneFolderAsync(
      folder,
      rule: (sub) => _checkIfId0(sub),
      success: (sub) {
        //logger.d("FolderPicking: ID0 Folder Auto Picked - ${id0Folder?.path}");
        id0Folder = sub;
      },
      fail: (_) {
        logger.e("FolderPicking: 0 or more than 1 ID0 found");
        //showSnackbar(_s().pick_id0_not_1)
      },
    );
  }

  Future<bool> _checkIfId0(Directory folder) async {
    if (!kId0Regex.hasMatch(folder.name)) {
      return false;
    }
    return await folder.list().asyncAny((sub) => FileSystemUtils.isDirectory(sub));
  }

  Future<bool> _checkIfId1(Directory folder) async {
    return _getHax(folder) != null || kId1Regex.hasMatch(folder.name);
  }

  Hax? _getHax(Directory folder) {
    return Hax.findById1(folder.name);
  }

  Future<DirectoryHaxPair?> _findMatchingHaxId1([Directory? folder]) async {
    folder ??= id0Folder;
    DirectoryHaxPair? ret;
    Hax? hax;
    await findJustOneFolder(
      folder,
      rule: (sub) {
        final tmpHax = _getHax(sub);
        if (tmpHax != null) {
          hax = tmpHax;
          return true;
        }
        return false;
      },
      success: (sub) => ret = DirectoryHaxPair(sub, hax!),
      fail: (count) {
        if (count > 1) {
          logger.e("Prepare: Multiple Hax ID1 ???");
          //showSnackbar(_s().pick_multi_hax_id1)
          // WTF???
        }
      },
    );
    return ret;
  }

  Future<Directory?> _findId1Common(Directory? folder, bool backupIdOrNot) async {
    folder ??= id0Folder;
    Directory? ret;
    await findJustOneFolderAsync(
      folder,
      rule: (sub) async => await _checkIfId1(sub) && sub.name.endsWith(kOldId1Suffix) == backupIdOrNot,
      success: (sub) => ret = sub,
    );
    return ret;
  }
  Future<Directory?> _findBackupId1([Directory? folder]) => _findId1Common(folder, true);
  Future<bool> _findId1([Directory? folder]) async {
    final tmpId1 = await _findId1Common(folder, false);
    if (tmpId1 != null) {
      id1Folder = tmpId1;
      return true;
    }
    return false;
  }

  Future<Directory?> _findHaxFolder([Directory? folder]) async {
    folder ??= id0Folder;
    if (id0Folder == null || variant == null) {
      return null;
    }
    final hax = Hax.find(variant!);
    final tmpId1HaxFolder = await id0Folder?.directory(hax?.id1);
    if (tmpId1HaxFolder != null) {
      id1HaxFolder = tmpId1HaxFolder;
    }
    return id1HaxFolder;
  }

  void _doSetup() async {
    final variant = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VariantSelector()),
    );
    if (variant == null) {
      return;
    }
    this.variant = variant;
    setState(() {
      _stage = Stage.doingWork;
    });
    _showLoading(null, _s().setup_loading);
    await _doActualSetup();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    setState(() {
      _stage = Stage.postSetup;
    });
  }

  Future<void> _doActualSetup() async {
    logger.d("Setup: Setup - ${variant?.model.name} ${variant?.version.major}.${variant?.version.minor}");
    if (variant == null) {
      logger.e("Setup: No variant selected");
      return;
    }
    final hax = Hax.find(variant!);
    if (hax == null) {
      logger.e("Setup: No available hax");
      return;
    }
    if (!await _findId1()) {
      logger.e("Setup: ID1 Issue");
      await _showAlert(null, _s().setup_alert_setup_title, _s().setup_alert_no_or_more_id1);
      return;
    }

    await _doSetupSDRoot();

    try {
      id1Folder = await id1Folder?.renameAddSuffix(kOldId1Suffix);
    } on FileSystemException catch (e) {
      logger.e("Setup: failed to rename id1");
      logger.d("Setup: Error: ${e.message} @ ${e.path}");
      return;
    }
    id1HaxFolder = await id0Folder?.directory(hax.id1, create: true);
    if (id1HaxFolder == null) {
      logger.e("Setup: failed to create hax id1");
      return;
    }

    await _createDummyDbs();
    await _showAlert(null, _s().setup_alert_hax_id1_created_title, "${_s().setup_alert_hax_id1_created}\n\n${_s().setup_alert_dummy_mii_maker_and_db_reset}", _buildAlertVisualAidButtonsFunc);
  }

  Future<bool> _checkIfDummyDbs() async {
    final dbs = await id1HaxFolder?.directory("dbs", caseInsensitive: true);
    if (dbs == null) {
      logger.i("Setup: dbs doesn't exist");
      await _createDummyDbs();
      return true;
    }
    final title = await dbs.file("title.db", caseInsensitive: true);
    final import = await dbs.file("import.db", caseInsensitive: true);
    if (title == null || import == null) {
      logger.i("Setup: db file doesn't exist");
      await _createDummyDbs();
      return true;
    }
    if (await title.length() == 0 || await import.length() == 0) {
      logger.e("Setup: db files are dummy!");
      await _showAlert(null, _s().setup_alert_dummy_db_title, "${_s().setup_alert_dummy_db_found}\n\n${_s().setup_alert_dummy_db_reset}", _buildAlertVisualAidButtonsFunc);
      return true;
    }
    if (await title.length() != 0x31e400 || await import.length() != 0x31e400) {
      logger.e("Setup: db files are likely corrupted!");
      await _showAlert(null, _s().setup_alert_dummy_db_title, "${_s().setup_alert_dummy_db_corrupted}\n\n${_s().setup_alert_dummy_db_reset}", _buildAlertVisualAidButtonsFunc);
      return true;
    }
    return false;
  }

  Future<bool> _createDummyDbs() async {
    if (id1HaxFolder == null) {
      return false;
    }
    Directory? dbs;
    try {
      dbs = await id1HaxFolder?.directory("dbs", caseInsensitive: true) ??
          await id1HaxFolder?.directory("dbs", create: true);
    } on FileSystemException catch (e) {
      logger.e("Setup: can't create dbs folder!\n$e");
      return false;
    }
    try {
      await dbs?.file("title.db", caseInsensitive: true) ??
        await dbs?.file("title.db", create: true).then((f) => f?.writeAsBytes([], flush: true));
    } on FileSystemException catch (e) {
      logger.e("Setup: can't create title.db!\n$e");
      return false;
    }
    try {
      await dbs?.file("import.db", caseInsensitive: true) ??
        await dbs?.file("import.db", create: true).then((f) => f?.writeAsBytes([], flush: true));
    } on FileSystemException catch (e) {
      logger.e("Setup: can't create title.db!\n$e");
      return false;
    }
    return true;
  }

  Future<void> _doSetupSDRoot() async {
    if (sdRoot != null) {
    }
  }

  void _doInjectTrigger() async {
    await (await id1HaxExtdataFolder?.file(kTriggerFile, create: true))?.writeAsBytes([], flush: true);
    _checkInjectState();
  }

  void _doRemoveTrigger() async {
    await (await id1HaxExtdataFolder?.file(kTriggerFile))?.delete();
    _checkInjectState();
  }

  void _doRemove() async {
    logger.d("Setup: Remove - ${variant?.model} ${variant?.version.major}.${variant?.version.minor}");
    setState(() {
      _stage = Stage.doingWork;
    });
    _showLoading(null, _s().remove_loading);
    await (await _findHaxFolder())?.delete(recursive: true);
    final backupId1 = await _findBackupId1();
    await backupId1?.renameInplace(backupId1.name.replaceAll(kOldId1Suffix, ''));
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    variant = null;
    setState(() {
      _stage = Stage.setup;
    });
  }

  Widget _genButton(BuildContext context, List<Stage> stages, Function() action, String text) {
    const double margin = 8;
    return Container(
      margin: const EdgeInsets.fromLTRB(margin, 0, margin, margin),
      child: FilledButton(
        onPressed: (stages.isEmpty || stages.contains(_stage)) ? action : null,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(S.of(context).title_installer),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _genButton(
              context,
              [],
              _pickFolder,
              S.of(context).installer_button_pick_3ds
          ),
          [Stage.postSetup, Stage.inject, Stage.trigger].contains(_stage) ?
            _genButton(
              context,
              [Stage.postSetup, Stage.inject, Stage.trigger],
              _checkState,
              S.of(context).installer_button_check
            )
            :
            _genButton(
              context,
              [Stage.setup],
              _doSetup,
              S.of(context).installer_button_setup
            )
          ,
          _genButton(
              context,
              [Stage.inject],
              _doInjectTrigger,
              S.of(context).installer_button_inject_trigger
          ),
          _genButton(
              context,
              [Stage.trigger],
              _doRemoveTrigger,
              S.of(context).installer_button_remove_trigger
          ),
          _genButton(
              context,
              [Stage.postSetup, Stage.inject, Stage.trigger, Stage.broken],
              _doRemove,
              S.of(context).installer_button_remove
          ),
        ],
      ),
    );
  }
}

class DirectoryHaxPair {
  DirectoryHaxPair(this.folder, this.hax);
  Directory folder;
  Hax hax;
}

class VariantSelector extends StatefulWidget {
  const VariantSelector({super.key});

  @override
  State<VariantSelector> createState() => _VariantSelectorState();
}

class _VariantSelectorState extends State<VariantSelector> {
  Model _model = Model.unknown;
  //int _major = -1;
  final _major = 11;
  int _minor = -1;

  void _checkReturn(BuildContext context) {
    if (_model != Model.unknown && _major != -1 && _minor != -1) {
      Navigator.pop(context, Variant(_model, Version(_major, _minor)));
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

  Widget genDropdown(BuildContext context, int max, int Function()? value, Function(int?)? action) {
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
              genDropdown(context, 11, () => _major, null),
              /*
              genDropdown(context, 11, () => _major, (val) { setState(() {
                _major = val ?? -1;
              }); }),
               */
              const Text("."),
              genDropdown(context, 17, () => _minor, (val) { setState(() {
                _minor = val ?? -1;
              }); }),
              const Text("."),
              genDropdown(context, 0, null, null),
            ],
          ),
        ],
      ),
    );
  }
}
