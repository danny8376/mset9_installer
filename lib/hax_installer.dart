import 'dart:async';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;

import 'console.dart';
import 'consts.dart';
import 'hax.dart';
import 'io.dart';
import 'io_utils.dart';
import 'root_check.dart';
import 'string_utils.dart';
import 'talker.dart';

enum HaxStage { pickFolder, folderPicked, cardRemoved, /*pickVariant,*/ postSetup, readyToInject, doExploit, broken, doingWork }

enum FolderAssignmentExceptionType { noN3DS, noId0, multipleId0, id1Picked, unknown }
enum HaxConfirmationType { autoSdRootSetup, sdRootSetupIncludeCorruptedUnknownOptional }
enum HaxAlertType {
  noHaxAvailable,
  multipleHaxId1,
  noId1,
  multipleId1,
  sdSetupFailed,
  dummyDb,
  corruptedDb,
  extdataFolderMissing,
  homeMenuExtdataMissing,
  miiMakerExtdataMissing
}
//enum HaxExceptionType {  }

class HaxInstaller {
  HaxStage _stage = HaxStage.pickFolder;
  bool _workIsCheck = false;
  bool get workIsCheck => _workIsCheck;

  bool extraVersions = false;
  bool looseRootCheck = false;
  bool legacyCode = false;

  Directory? sdRoot;
  Directory? n3dsFolder;
  Directory? id0Folder;
  Variant? _variant;

  Directory? id1Folder;
  Directory? id1HaxFolder;
  Directory? id1HaxExtdataFolder;

  Map<String, CheckState>? _sdRootMissing;
  Map<String, CheckState>? get _sdRootMissingClone => _sdRootMissing == null ? null : {..._sdRootMissing!};
  dynamic _folderAndDriveUpdateWatcherHandle;
  Directory? _folderAndDriveUpdateWatchRoot;
  bool _pauseFolderAndDriveUpdateWatcher = false;

  void Function(HaxStage) stageUpdateCallback;
  void Function(HaxAlertType) alertCallback;
  void Function(HaxConfirmationType, Future<bool> Function(bool), [dynamic]) confirmationCallback;

  HaxInstaller({
    required this.stageUpdateCallback,
    required this.alertCallback,
    required this.confirmationCallback,
  }) {
    initWatcher();
  }

  HaxStage get stage => _stage;

  Variant? get variant => _variant;

  Future<void> checkState({bool silent = false, bool skipSdRoot = false, bool sdFailed = false}) => _exceptionGuard(
    faultResult: null,
    isChecking: true,
    switchStageToDoingWork: true,
    onlyRecoverStageWhenException: true,
    pauseFolderAndDriveUpdateWatcherWhenDoingWork: true,
    work: () async {
      talker.debug("Common: Checking state");
      if (id0Folder == null) {
        stageUpdateCallback(_stage = HaxStage.pickFolder);
        return;
      }
      if (await id0Folder?.exists() != true) {
        stageUpdateCallback(_stage = HaxStage.cardRemoved);
        return;
      }
      final matching = await _findHaxId1();
      if (matching != null) {
        id1HaxFolder = matching.folder;
        _variant = matching.hax.dummyVariant;
        checkInjectState(silent: silent, skipSdRoot: skipSdRoot, sdFailed: sdFailed);
      } else if ((await _findId1(any: true) != null && await _findBackupId1(any: true) != null) ||
          (await _findId1(any: true) != null && await _findHaxId1(any: true) != null)) {
        stageUpdateCallback(_stage = HaxStage.broken);
      /*
      } else if (_stage == HaxStage.pickVariant && _variant != null) {
        setupHaxId1();
       */
      } else {
        stageUpdateCallback(_stage = HaxStage.folderPicked);
      }
    },
  );

  Future<void> checkInjectState({bool silent = false, bool skipSdRoot = false, bool sdFailed = false}) => _exceptionGuard(
    faultResult: null,
    isChecking: true,
    switchStageToDoingWork: true,
    onlyRecoverStageWhenException: true,
    pauseFolderAndDriveUpdateWatcherWhenDoingWork: true,
    work: () async {
      talker.debug("Common: Checking inject state");
      if (id1HaxFolder == null) {
        // avoid stuck in doingWork state
        stageUpdateCallback(_stage = HaxStage.broken);
        return;
      }
      if (await id1HaxFolder?.exists() != true) {
        stageUpdateCallback(_stage = HaxStage.cardRemoved);
        return;
      }
      if (sdFailed || (!skipSdRoot && await checkSDRootMissing(silent: silent, ignoreOptional: true) != null)) {
        stageUpdateCallback(_stage = HaxStage.postSetup);
        return;
      }
      if (await _checkIfDummyDbs(silent: silent)) {
        talker.warning("Check: Hax ID1 dbs is missing/dummy");
        stageUpdateCallback(_stage = HaxStage.postSetup);
        return;
      }
      id1HaxExtdataFolder = await id1HaxFolder?.directory("extdata", caseInsensitive: true);
      if (id1HaxExtdataFolder == null) {
        talker.warning("Check: Hax ID1 extdata folder is missing");
        if (!silent) {
          alertCallback(HaxAlertType.extdataFolderMissing);
        }
        stageUpdateCallback(_stage = HaxStage.postSetup);
        return;
      }
      final extdata0 = await id1HaxExtdataFolder?.directory("00000000");
      if (extdata0 == null) {
        talker.error("Check: Hax ID1 extdata/00000000 folder is missing!");
        if (!silent) {
          alertCallback(HaxAlertType.extdataFolderMissing);
        }
        stageUpdateCallback(_stage = HaxStage.postSetup);
        return;
      }
      final extdataPair = await ExtDataIdPair.findDirectory(extdata0);
      if (extdataPair == null) {
        final partialExtdataPair = await ExtDataIdPair.findDirectory(extdata0, partialMatch: true);
        if (partialExtdataPair == null || partialExtdataPair.homeMenu == null) {
          if (partialExtdataPair == null) {
            talker.warning("Check: No home menu extdata folder!");
          } else {
            talker.error("Check: No home menu extdata folder but mii maker folder exists???");
          }
          if (!silent) {
            alertCallback(HaxAlertType.homeMenuExtdataMissing);
          }
        } else if (partialExtdataPair.miiMaker == null) {
          talker.warning("Check: No mii maker extdata folder!");
          if (!silent) {
            alertCallback(HaxAlertType.miiMakerExtdataMissing);
          }
        }
        stageUpdateCallback(_stage = HaxStage.postSetup);
        return;
      }
      if (await id1HaxExtdataFolder?.file(kTriggerFile, caseInsensitive: true) == null) {
        stageUpdateCallback(_stage = HaxStage.readyToInject);
      } else {
        stageUpdateCallback(_stage = HaxStage.doExploit);
      }
    }
  );

  Future<void> _handleFolderAndDriveUpdate(List<String>? updates) async {
    if (_folderAndDriveUpdateWatchRoot == null) {
      return; // something is very wrong
    }
    if (_pauseFolderAndDriveUpdateWatcher) {
      // let's hope user know that they shouldn't mess with files when
      // the setup process is running... I guess... hope so
      // we can't easily distinguish events between user and app anyway
      return;
    }
    if (updates == null) {
      try {
        if (await _folderAndDriveUpdateWatchRoot?.exists() == true) {
          return checkState(silent: true);
        }
      } on FileSystemException { // ignore
      }
      return stageUpdateCallback(_stage = HaxStage.cardRemoved);
    }
    if (updates.isEmpty) {
      return checkState(silent: true);
    }
    bool id0Altered = false;
    if (_folderAndDriveUpdateWatchRoot == id0Folder) {
      id0Altered = true;
    } else {
      final id0 = id0Folder!.name;
      final checkList = await RootCheckList.load();
      updates.removeWhere((path) {
        final pathSeg = p.split(path);
        if (_folderAndDriveUpdateWatchRoot == n3dsFolder) {
          id0Altered = pathSeg.firstOrNull?.equalsIgnoreAsciiCase(id0) == true;
          return true;
        }
        if (pathSeg.firstOrNull?.equalsIgnoreAsciiCase(kN3dsFolder) != true) {
          return !checkList.pathList.any((e) => path.equalsIgnoreAsciiCase(e));
        }
        if (pathSeg.elementAtOrNull(1)?.equalsIgnoreAsciiCase(id0) == true) {
          id0Altered = true;
        }
        return true;
      });
    }
    if (id0Altered && _sdRootMissing == null && updates.isEmpty) {
      checkInjectState(silent: true, skipSdRoot: true);
    }
    if (sdRoot == null) {
      return;
    }
    final missing = await sdRootCheck(sdRoot!, fileList: updates, loose: looseRootCheck);
    if (_sdRootMissing == null) {
      _sdRootMissing = missing;
      if (missing?.values.where((v) => !v.optional).isEmpty == false) {
        stageUpdateCallback(_stage = HaxStage.postSetup);
      }
      return;
    }
    for (final path in updates) {
      if (missing?.containsKey(path) != true) {
        _sdRootMissing?.remove(path);
      } else if (missing != null) {
        _sdRootMissing?[path] = missing[path]!;
      }
    }
    if (_sdRootMissing?.isEmpty == true) {
      _sdRootMissing = null;
      checkState(silent: true, skipSdRoot: true);
    }
  }

  Future<void> _watchFolderAndDriveUpdate() async {
    // always unwatch, the implementation is supposed to handle null
    // (or the implementation actually don't need to unwatch, still pass null)
    unwatchFolderAndDriveUpdate(_folderAndDriveUpdateWatcherHandle);
    _folderAndDriveUpdateWatchRoot = sdRoot ?? n3dsFolder ?? id0Folder;
    _folderAndDriveUpdateWatcherHandle = await watchFolderAndDriveUpdate(_folderAndDriveUpdateWatchRoot!, _handleFolderAndDriveUpdate);
    _pauseFolderAndDriveUpdateWatcher = false;
  }

  Future<void> checkAndAssignFolders(Directory dir) async {
    final (root, n3ds, id0, missing, stage) = (sdRoot, n3dsFolder, id0Folder, _sdRootMissing, _stage);
    try {
      var result = await _checkAndAssignFolders(dir);
      if (canAccessParentOfPicked) {
        while (!result && !dir.isRoot) {
          dir = dir.parent;
          result = await _checkAndAssignFolders(dir);
        }
      }
      if (!result) {
        talker.error("FolderPicking: Check: Unknown Folder Picked");
        throw const FolderAssignmentException(FolderAssignmentExceptionType.unknown);
      }
      _watchFolderAndDriveUpdate();
      checkState();
    } on FolderAssignmentException {
      sdRoot = root;
      n3dsFolder = n3ds;
      id0Folder = id0;
      _sdRootMissing = missing;
      if (_stage != stage) {
        stageUpdateCallback(_stage = stage);
      }
      rethrow;
    } catch (e, st) {
      sdRoot = root;
      n3dsFolder = n3ds;
      id0Folder = id0;
      _sdRootMissing = missing;
      if (_stage != stage) {
        stageUpdateCallback(_stage = stage);
      }
      talker.handle(e, st);
    }
  }

  Future<bool> _checkAndAssignFolders(Directory dir) async {
    //talker.debug("FolderPicking: check for folder ${dir.path}");
    if (kN3dsFolder.equalsIgnoreAsciiCase(dir.name)) {
      talker.debug("FolderPicking: Check: Nintendo 3DS Folder Picked");
      n3dsFolder = dir;
      if (canAccessParentOfPicked) {
        sdRoot = n3dsFolder!.parent;
      } else {
        sdRoot = null;
        _sdRootMissing = null;
      }
      return await _pickId0FromN3DS();
    } else if (await _checkIfId0(dir)) {
      talker.debug("FolderPicking: Check: ID0 Folder Picked");
      id0Folder = dir;
      if (canAccessParentOfPicked) {
        n3dsFolder = id0Folder!.parent;
        sdRoot = n3dsFolder!.parent;
      } else {
        sdRoot = n3dsFolder = null;
        _sdRootMissing = null;
      }
      return true;
    } else if (await _checkIfId1(dir)) {
      if (canAccessParentOfPicked) {
        talker.debug("FolderPicking: Check: ID1 Folder Picked");
        id0Folder = dir.parent;
        n3dsFolder = id0Folder!.parent;
        sdRoot = n3dsFolder!.parent;
      } else {
        talker.error("FolderPicking: Check: ID1 Folder Picked");
        throw const FolderAssignmentException(FolderAssignmentExceptionType.id1Picked);
      }
      return true;
    } else if (await _pickN3DSFromSDRoot(dir)) {
      talker.debug("FolderPicking: Check: SD Root Picked");
      return true;
    }
    return false;
  }

  Future<bool> _pickN3DSFromSDRoot(Directory folder) async {
    final sub = await folder.directory(kN3dsFolder, caseInsensitive: true);
    if (sub != null && await FileSystemUtils.isDirectory(sub)) {
      sdRoot = folder;
      n3dsFolder = sub;
      await _pickId0FromN3DS();
      return true;
    }
    return false;
  }

  Future<bool> _pickId0FromN3DS([Directory? folder]) {
    folder ??= n3dsFolder;
    return findJustOneFolder(
      folder,
      rule: (sub) => _checkIfId0(sub),
      success: (sub) {
        //talker.debug("FolderPicking: ID0 Folder Auto Picked - ${id0Folder?.path}");
        id0Folder = sub;
      },
      fail: (count) {
        talker.error("FolderPicking: 0 or more than 1 ID0 found");
        if (count == 0) {
          throw const FolderAssignmentException(FolderAssignmentExceptionType.noId0);
        } else {
          throw FolderAssignmentException(FolderAssignmentExceptionType.multipleId0, count);
        }
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

  Future<DirectoryHaxPair?> _findHaxId1({Directory? from, bool any = false}) async {
    from ??= id0Folder;
    DirectoryHaxPair? ret;
    Hax? hax;
    await (any ? findFirstMatchingFolder : findJustOneFolder)(
      from,
      rule: (sub) async {
        final tmpHax = _getHax(sub);
        if (tmpHax != null) {
          hax = tmpHax;
          return true;
        }
        return false;
      },
      success: (sub) { ret = DirectoryHaxPair(sub, hax!); },
      fail: (count) {
        if (count > 1) {
          talker.error("Prepare: Multiple hax ID1 ???");
          //showSnackbar(_s().pick_multi_hax_id1)
          // WTF???
        }
      },
    );
    return ret;
  }

  Future<Directory?> _findId1Common(Directory? from, {required bool backupId, bool any = false, void Function(int)? error}) async {
    from ??= id0Folder;
    Directory? ret;
    await (any ? findFirstMatchingFolder : findJustOneFolder)(
      from,
      rule: (sub) async => await _checkIfId1(sub) && sub.name.endsWith(kOldId1Suffix) == backupId,
      success: (sub) => ret = sub,
    );
    return ret;
  }
  Future<Directory?> _findBackupId1({Directory? from, bool any = false, void Function(int)? error}) =>
      _findId1Common(from, backupId: true, any: any, error: error);
  Future<Directory?> _findId1({Directory? from, bool any = false, void Function(int)? error}) =>
      _findId1Common(from, backupId: false, any: any, error: error);

  Future<Directory?> _findHaxFolder([Directory? folder]) async {
    folder ??= id0Folder;
    if (id0Folder == null || _variant == null) {
      return null;
    }
    final hax = Hax.find(_variant!);
    final tmpId1HaxFolder = await id0Folder?.directory(hax?.id1);
    if (tmpId1HaxFolder != null) {
      id1HaxFolder = tmpId1HaxFolder;
    }
    return id1HaxFolder;
  }

  Future<bool> _checkIfDummyDbs({bool silent = false}) async {
    final dbs = await id1HaxFolder?.directory("dbs", caseInsensitive: true);
    if (dbs == null) {
      talker.warning("Setup: dbs doesn't exist");
      await _createDummyDbs();
      return true;
    }
    final title = await dbs.file("title.db", caseInsensitive: true);
    final import = await dbs.file("import.db", caseInsensitive: true);
    if (title == null || import == null) {
      talker.error("Setup: db file doesn't exist");
      await _createDummyDbs();
      return true;
    }
    if (await title.length() == 0 || await import.length() == 0) {
      talker.warning("Setup: db files are dummy!");
      if (!silent) {
        alertCallback(HaxAlertType.dummyDb);
      }
      return true;
    }
    if (await title.length() != 0x31e400 || await import.length() != 0x31e400) {
      talker.error("Setup: db files are corrupted!");
      if (!silent) {
        alertCallback(HaxAlertType.corruptedDb);
      }
      return true;
    }
    return false;
  }

  Future<bool> _createDummyDbs() async {
    if (id1HaxFolder == null) {
      talker.error("Setup: id1HaxFolder missing!");
      return false;
    }
    Directory? dbs;
    try {
      dbs = await id1HaxFolder?.directory("dbs", caseInsensitive: true) ??
          await id1HaxFolder?.directory("dbs", create: true);
    } on FileSystemException catch (e) {
      talker.error("Setup: can't create dbs folder!", e);
      return false;
    }
    try {
      await dbs?.file("title.db", caseInsensitive: true) ??
          await dbs?.file("title.db", create: true).then((f) => f?.writeAsBytes([], flush: true));
    } on FileSystemException catch (e) {
      talker.error("Setup: can't create title.db!", e);
      return false;
    }
    try {
      await dbs?.file("import.db", caseInsensitive: true) ??
          await dbs?.file("import.db", create: true).then((f) => f?.writeAsBytes([], flush: true));
    } on FileSystemException catch (e) {
      talker.error("Setup: can't create title.db!", e);
      return false;
    }
    return true;
  }

  Future<T> _exceptionGuard<T>({
    required T faultResult,
    bool isChecking = false,
    bool switchStageToDoingWork = false,
    bool onlyRecoverStageWhenException = false,
    bool pauseFolderAndDriveUpdateWatcherWhenDoingWork = false,
    required Future<T> Function() work,
    Future<void> Function(T result, bool exception)? done,
  }) async {
    final previousStage = _stage;
    bool errorOut = false;
    _workIsCheck = isChecking;
    if (switchStageToDoingWork && previousStage != HaxStage.doingWork) {
      stageUpdateCallback(_stage = HaxStage.doingWork);
    }
    T result = faultResult;
    final watcherState = _pauseFolderAndDriveUpdateWatcher;
    if (pauseFolderAndDriveUpdateWatcherWhenDoingWork) {
      _pauseFolderAndDriveUpdateWatcher = true;
    }
    try {
      result = await work();
    } catch (e, st) {
      errorOut = true;
      talker.handle(e, st);
    }
    // if the work is already pause, don't resume it from us
    if (pauseFolderAndDriveUpdateWatcherWhenDoingWork && !watcherState) {
      _pauseFolderAndDriveUpdateWatcher = false;
    }
    _workIsCheck = false;
    if (done != null) {
      await done(result, errorOut);
    } else if (switchStageToDoingWork
      && previousStage != HaxStage.doingWork
      && (!onlyRecoverStageWhenException || errorOut)
    ) {
      stageUpdateCallback(_stage = previousStage);
    }
    return result;
  }

  Future<Map<String, CheckState>?> checkSDRootMissing({bool silent = false, bool ignoreOptional = false}) async {
    if (sdRoot == null) { // always pass when unable to check
      return null;
    }
    if (await sdRoot?.exists() != true) {
      stageUpdateCallback(_stage = HaxStage.cardRemoved);
      return null;
    }

    talker.debug("Setup: Checking SD root files...");
    _sdRootMissing = await sdRootCheck(sdRoot!, loose: looseRootCheck);
    //talker.debug(missing);
    if (!silent && _sdRootMissing != null) {
      final completer = Completer();
      confirmationCallback(
          HaxConfirmationType.autoSdRootSetup,
          (answer) async {
            if (!answer) {
              completer.complete(false);
              return false;
            }
            final result = await setupSDRoot();
            completer.complete(result);
            return result;
          },
          _sdRootMissingClone
      );
      if (await completer.future) {
        _sdRootMissing = await sdRootCheck(sdRoot!, loose: looseRootCheck);
      }
    }
    final missing = _sdRootMissingClone;
    if (ignoreOptional) {
      missing?.removeWhere((k, v) => v.optional);
    }
    return missing?.isEmpty == true ? null : missing;
  }

  Future<bool> switchVariant(Variant variant) async {
    switch (_stage) {
      case HaxStage.pickFolder:
      //case HaxStage.folderPicked:
      case HaxStage.cardRemoved:
      case HaxStage.broken:
      case HaxStage.doingWork:
        talker.error("HaxInstaller: Shouldn't set variant at this stage");
        throw Exception("Shouldn't set variant at this stage");
      case HaxStage.folderPicked:
      //case HaxStage.pickVariant:
        talker.debug("Setup: Set Variant - ${_variant?.model.name} ${_variant?.version.major}.${_variant?.version.minor}");
        _variant = variant;
      case HaxStage.postSetup:
      case HaxStage.readyToInject:
      case HaxStage.doExploit:
        talker.debug("Setup: Switch Variant - ${variant.model.name} ${variant.version.major}.${variant.version.minor}");
        if (id1HaxFolder == null) {
          return false;
        }
        final hax = Hax.find(variant);
        if (hax == null) {
          talker.error("Setup: Switch Variant - No available hax");
          alertCallback(HaxAlertType.noHaxAvailable);
          return false;
        }
        try {
          id1HaxFolder = await id1HaxFolder?.renameInplace(legacyCode ? hax.legacyId1 : hax.id1);
        } on FileSystemException catch (e) {
          talker.error("Setup: Switch Variant - Failed to rename hax ID1", e);
          return false;
        }
        _variant = variant;
        return true;
    }
    return false; // should never reach here?
  }

  Future<bool> setupHaxId1() => _exceptionGuard(
    faultResult: false,
    switchStageToDoingWork: true,
    pauseFolderAndDriveUpdateWatcherWhenDoingWork: true,
    work: () async {
      talker.debug("Setup: Setup - ${_variant?.model.name} ${_variant?.version.major}.${_variant?.version.minor}");
      if (_variant == null) {
        talker.error("Setup: No variant selected");
        return false;
      }
      final hax = Hax.find(_variant!);
      if (hax == null) {
        talker.error("Setup: No available hax");
        return false;
      }
      if (await id0Folder?.exists() != true) {
        stageUpdateCallback(_stage = HaxStage.cardRemoved);
        return false;
      }

      final tmpId1 = await _findId1(error: (count) {
        talker.error("Setup: ID1 Issue");
        alertCallback(count == 0 ? HaxAlertType.noId1 : HaxAlertType.multipleId1);
      });
      if (tmpId1 == null) {
        return false;
      }
      id1Folder = tmpId1;

      if (!await setupSDRoot()) {
        return false;
      }

      talker.debug("Setup: Setting up hax ID1...");
      try {
        id1Folder = await id1Folder?.renameAddSuffix(kOldId1Suffix);
      } on FileSystemException catch (e) {
        talker.error("Setup: Failed to rename ID1");
        talker.debug("Setup: Error: ${e.message} @ ${e.path}");
        return false;
      }
      id1HaxFolder = await id0Folder?.directory(legacyCode ? hax.legacyId1 : hax.id1, create: true);
      if (id1HaxFolder == null) {
        talker.error("Setup: Failed to create hax ID1");
        return false;
      }

      if (!await _createDummyDbs()) {
        return false;
      }
      return true;
    },
    done: (result, errorOut) async {
      (result ? checkInjectState : checkState)(silent: true);
    },
  );

  Future<bool> setupSDRoot() => _exceptionGuard(
    faultResult: false,
    switchStageToDoingWork: true,
    pauseFolderAndDriveUpdateWatcherWhenDoingWork: true,
    work: () async {
      if (sdRoot == null) {
        return true;
      }
      if (await sdRoot?.exists() != true) {
        stageUpdateCallback(_stage = HaxStage.cardRemoved);
        return false;
      }
      final missing = _sdRootMissing = await checkSDRootMissing(silent: true);
      if (missing == null) {
        talker.debug("Setup - SD root: no missing");
        return true;
      }
      var getCorruptedUnknownOptional = true;
      if (missing.entries.any((entry) => entry.value.optional)) {
        final completer = Completer();
        confirmationCallback(
          HaxConfirmationType.sdRootSetupIncludeCorruptedUnknownOptional,
          (answer) async {
            completer.complete(answer);
            return true;
          },
        );
        getCorruptedUnknownOptional = await completer.future;
        talker.debug("getCorruptedUnknownOptional: $getCorruptedUnknownOptional");
      }
      talker.debug("Setup - SD root: Downloading files...");
      final fileList = missing.entries.where((e) =>
          getCorruptedUnknownOptional ||
          (e.value.state == CheckStateState.missing && !e.value.optional)
      ).map((e) => e.key);
      //talker.debug(fileList);
      await downloadSdRootFiles(sdRoot!, fileList: List.unmodifiable(fileList));
      final verify = _sdRootMissing = await checkSDRootMissing(silent: true);
      //talker.debug(verify);
      if (verify != null && verify.keys.any((e) => fileList.contains(e))) {
        talker.debug("Setup - SD root: Failed to get all files!");
        alertCallback(HaxAlertType.sdSetupFailed);
        return false;
      }
      talker.debug("Setup - SD root: Succeed!");
      return true;
    },
  );

  Future<bool> injectTrigger() => _exceptionGuard(
    faultResult: false,
    switchStageToDoingWork: false,
    pauseFolderAndDriveUpdateWatcherWhenDoingWork: true,
    work: () async =>
        await (await id1HaxExtdataFolder?.file(kTriggerFile, create: true))?.writeAsBytes([], flush: true) != null,
    done: (result, errorOut) async {
      checkInjectState(skipSdRoot: true);
    }
  );

  Future<bool> removeTrigger() => _exceptionGuard(
    faultResult: false,
    switchStageToDoingWork: false,
    pauseFolderAndDriveUpdateWatcherWhenDoingWork: true,
    work: () async => await (await id1HaxExtdataFolder?.file(kTriggerFile))?.delete() != null,
    done: (result, errorOut) async {
      checkInjectState(skipSdRoot: true);
    },
  );

  Future<bool> removeHaxId1() => _exceptionGuard(
    faultResult: false,
    switchStageToDoingWork: true,
    pauseFolderAndDriveUpdateWatcherWhenDoingWork: true,
    work: () async {
      talker.debug("Setup: Remove - ${_variant?.model} ${_variant?.version.major}.${_variant?.version.minor}");
      await (await _findHaxFolder())?.delete(recursive: true);
      final backupId1 = await _findBackupId1();
      await backupId1?.renameInplace(backupId1.name.replaceAll(kOldId1Suffix, ''));
      return true;
    },
    done: (result, errorOut) async {
      _variant = null;
      checkState(silent: true, skipSdRoot: true);
    },
  );

  Future<bool> checkIfCfwInstalled() => _exceptionGuard(
    faultResult: false,
    isChecking: true,
    work: () async {
      if (sdRoot == null) {
        return true; // can't check, return true and hope user knows stuff
      }
      var installerDir = await sdRoot?.directory("boot9strap", caseInsensitive: true);
      installerDir ??= await sdRoot?.directory("ofi", caseInsensitive: true);
      return await installerDir?.list().asyncAny(
          (child) async =>
              await FileSystemUtils.isFile(child) &&
              kFirmBakRegex.hasMatch((child as FileSystemEntity).name)
      ) == true;
    },
  );
}

class DirectoryHaxPair {
  DirectoryHaxPair(this.folder, this.hax);
  Directory folder;
  Hax hax;
}

class FolderAssignmentException implements Exception {
  final FolderAssignmentExceptionType type;
  final int count; // for multiple folder exceptions
  const FolderAssignmentException(this.type, [this.count = 0]);
}
