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

const kNonRootEventsCleanupDuration = Duration(seconds: 2);

enum HaxStage { pickFolder, folderPicked, folderPickedWithError, cardRemoved, /*pickVariant,*/ postSetup, readyToInject, doExploit, broken, doingWork }

enum HaxConfirmationType { autoSdRootSetup, sdRootSetupIncludeCorruptedUnknownOptional }
enum HaxAlertType {
  noN3DS,
  noId0,
  multipleId0,
  noId1,
  multipleId1,
  id1Picked,
  unknownFolderPicked,
  brokenId0Contents,
  noHaxAvailable,
  multipleHaxId1,
  sdSetupFailed,
  dummyDb,
  corruptedDb,
  extdataFolderMissing,
  homeMenuExtdataMissing,
  miiMakerExtdataMissing,
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
  bool __cleanupRemainingNonRootEvents = false;
  Timer? _cleanupRemainingNonRootEventsTimer;
  bool get _cleanupRemainingNonRootEvents => __cleanupRemainingNonRootEvents;
  set _cleanupRemainingNonRootEvents(bool v) {
    if (__cleanupRemainingNonRootEvents && v) {
      return;
    }
    __cleanupRemainingNonRootEvents = v;
    if (v) {
      _cleanupRemainingNonRootEventsTimer = Timer(kNonRootEventsCleanupDuration, () {
        _cleanupRemainingNonRootEvents = false;
      });
    } else {
      _cleanupRemainingNonRootEventsTimer?.cancel();
      _cleanupRemainingNonRootEventsTimer = null;
    }
  }

  void Function(HaxStage) stageUpdateCallback;
  void Function(HaxAlertType, {dynamic additionalInfo}) alertCallback;
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

  Future<void> checkState({bool silent = false, bool skipSdRoot = false, bool sdFailed = false}) {
    final originalStage = _stage;
    return _exceptionGuard(
      faultResult: null,
      isChecking: true,
      switchStageToDoingWork: true,
      onlyRecoverStageWhenException: true,
      pauseFolderAndDriveUpdateWatcherWhenDoingWork: true,
      work: () async {
        talker.debug("Check: Checking state");
        //talker.debug("Check: Checking state", "StackTrace", StackTrace.current);
        if (originalStage == HaxStage.folderPickedWithError) {
          try {
            await checkAndAssignFolders(sdRoot!);
          } on FolderAssignmentException catch (e) {
            alertCallback(e.type, additionalInfo: e.count);
          }
          // checkAndAssignFolders will also call checkStage again,
          // so we're done regardless the result
          return;
        }
        if (id0Folder == null) {
          stageUpdateCallback(_stage = HaxStage.pickFolder);
          return;
        }
        if (await id0Folder?.exists() != true) {
          talker.debug("Check: ID0 folder missing, switch to cardRemoved");
          stageUpdateCallback(_stage = HaxStage.cardRemoved);
          return;
        }
        final id1 = await _checkAllId1();
        if (id1 == null) {
          talker.debug("Check: ID0 get unset somehow???");
          stageUpdateCallback(_stage = HaxStage.folderPickedWithError);
          return;
        }
        final countResults = id1.allCountResult;
        switch (countResults) {
          case (normal: _, backup: _Count.zero, haxAlike: _Count.zero): // normal clean case
            var newStage = HaxStage.folderPickedWithError;
            switch (countResults.normal) {
              case _Count.one:
                id1Folder = id1.normal;
                newStage = HaxStage.folderPicked;
              case _Count.zero:
                alertCallback(HaxAlertType.noId1);
              case _Count.more:
                alertCallback(HaxAlertType.multipleId1, additionalInfo: id1.normalCount);
            }
            stageUpdateCallback(_stage = newStage);
          case (normal: _Count.zero, backup: _, haxAlike: _Count.one):
            id1HaxFolder = id1.haxAlike;
            final hax = Hax.findById1(id1HaxFolder!.name);
            if (hax == null) {
              talker.error("Check: Non-existing hax ID1 ???");
              stageUpdateCallback(_stage = HaxStage.folderPickedWithError);
              return;
            }
            switch (countResults.backup) {
              case _Count.one:
                break; // normal, do nothing special
              case _Count.zero:
              // TODO: show alert about no backup
              //alertCallback(HaxAlertType.noBackupId1);
              case _Count.more:
              // TODO: show alert about multiple backup
              //alertCallback(HaxAlertType.multipleBackupId1, additionalInfo: id1.backupCount);
            }
            _variant = hax.dummyVariant;
            checkInjectState(silent: silent, skipSdRoot: skipSdRoot, sdFailed: sdFailed);
          case (normal: _Count.zero, backup: _Count.one, haxAlike: _Count.zero):
            talker.error("Check: Missing hax ID1 but have backup ID1");
            stageUpdateCallback(_stage = HaxStage.broken);
          case (normal: _, backup: _, haxAlike: _Count.more):
            talker.error("Check: Multiple hax ID1 ???");
            alertCallback(HaxAlertType.multipleHaxId1, additionalInfo: id1.haxAlikeCount);
            stageUpdateCallback(_stage = HaxStage.broken);
          // !!! remember to move case up if any handles differently !!!
          case (normal: _, backup: _Count.zero, haxAlike: _):
            // id1 exist with multiple hax
          case (normal: _Count.zero, backup: _Count.more, haxAlike: _Count.zero):
            // multiple backup
          case (normal: _Count.more, backup: _, haxAlike: _):
            // multiple id1 with backup and/or hax
          case (normal: _, backup: _, haxAlike: _Count.zero):
            // id1 exists with multiple backup
          case (normal: _Count.one, backup: _Count.one, haxAlike: _Count.one):
            // id1 exists with one backup and one hax
          case (normal: _Count.one, backup: _Count.more, haxAlike: _Count.one):
            // id1 exists with multiple backup and one hax

            // shared broken action
            alertCallback(HaxAlertType.brokenId0Contents);
            stageUpdateCallback(_stage = HaxStage.folderPickedWithError);
        }
      },
    );
  }

  Future<void> checkInjectState({bool silent = false, bool skipSdRoot = false, bool sdFailed = false}) => _exceptionGuard(
    faultResult: null,
    isChecking: true,
    switchStageToDoingWork: true,
    onlyRecoverStageWhenException: true,
    pauseFolderAndDriveUpdateWatcherWhenDoingWork: true,
    work: () async {
      talker.debug("Check: Checking inject state");
      //talker.debug("Check: Checking inject state", "StackTrace", StackTrace.current);
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
    // if (updates?.isEmpty != false) { // Checker is not happy with this...
    if (updates == null || updates.isEmpty || _stage == HaxStage.folderPickedWithError) {
      _cleanupRemainingNonRootEvents = false;
      try {
        if (await _folderAndDriveUpdateWatchRoot?.exists() == true) {
          return checkState(/* silent: true */);
        }
      } on FileSystemException { // ignore
      }
      return stageUpdateCallback(_stage = HaxStage.cardRemoved);
    }
    if (_cleanupRemainingNonRootEvents) {
      return;
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
        throw const FolderAssignmentException(HaxAlertType.unknownFolderPicked);
      }
      _watchFolderAndDriveUpdate();
      checkState();
    } on FolderAssignmentException catch (e) {
      // on desktop, allow root being kept selected and can simply check again later
      if (canAccessParentOfPicked && !const [HaxAlertType.noN3DS, HaxAlertType.unknownFolderPicked].contains(e.type)) {
        n3dsFolder = id0Folder = _sdRootMissing = null;
        stageUpdateCallback(_stage = HaxStage.folderPickedWithError);
        _watchFolderAndDriveUpdate();
        rethrow;
      }
      n3dsFolder = n3ds;
      id0Folder = id0;
      _sdRootMissing = missing;
      if (_stage != stage) {
        stageUpdateCallback(_stage = stage);
      }
      rethrow;
    } catch (e, st) {
      talker.handle(e, st);
      sdRoot = root;
      n3dsFolder = n3ds;
      id0Folder = id0;
      _sdRootMissing = missing;
      if (_stage != stage) {
        stageUpdateCallback(_stage = stage);
      }
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
        throw const FolderAssignmentException(HaxAlertType.id1Picked);
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
      success: (sub) async {
        //talker.debug("FolderPicking: ID0 Folder Auto Picked - ${sub.path}");
        id0Folder = sub;
      },
      fail: (count) {
        talker.error("FolderPicking: 0 or more than 1 ID0 found");
        if (count == 0) {
          throw const FolderAssignmentException(HaxAlertType.noId0);
        } else {
          throw FolderAssignmentException(HaxAlertType.multipleId0, count);
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

  Future<_Id1CheckResult?> _checkAllId1({Directory? from}) async {
    final r = _Id1CheckResult();
    from ??= id0Folder;
    if (from == null) {
      return null;
    }
    await for (final sub in from.list()) {
      if (!await FileSystemUtils.isDirectory(sub) || sub is! Directory) {
        continue;
      }
      final Directory(:name) = sub;
      if (kId1Regex.hasMatch(name)) {
        (name.endsWith(kOldId1Suffix) ? r.backupFolders : r.normalFolders).add(sub);
      }
      if (Hax.checkIfHaxId1(name)) {
        r.haxAlikeFolders.add(sub);
      }
    }
    return r;
  }

  Future<bool> _checkIfId1(Directory folder) async {
    return Hax.checkIfHaxId1(folder.name) || kId1Regex.hasMatch(folder.name);
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
      case HaxStage.folderPickedWithError:
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
        alertCallback(HaxAlertType.noHaxAvailable);
        return false;
      }
      if (await id0Folder?.exists() != true) {
        stageUpdateCallback(_stage = HaxStage.cardRemoved);
        return false;
      }

      if (await id1Folder?.exists() != true) {
        // force user to check again
        stageUpdateCallback(_stage = HaxStage.cardRemoved);
        return false;
      }

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
      final id1 = await _checkAllId1();
      if (id1 == null) {
        return false;
      }
      for (final haxId1 in id1.haxAlikeFolders) {
        try {
          await haxId1.delete(recursive: true);
        } on PathNotFoundException {
          try {
            final fixed = await haxId1.parent.directory(Hax.fixHaxPathName(haxId1.name));
            await fixed?.delete(recursive: true);
          } on PathNotFoundException { // ignore
          }
        }
      }
      if (id1.backupCount == 1) {
        final backupId1 = id1.backup;
        await backupId1.renameInplace(backupId1.name.replaceAll(kOldId1Suffix, ''));
        return true;
      }
      return false;
    },
    done: (result, errorOut) async {
      if (result) {
        _variant = null;
      }
      _cleanupRemainingNonRootEvents = true;
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
        (child) async => await FileSystemUtils.isFile(child)
          && kFirmBakRegex.hasMatch((child as FileSystemEntity).name)
      ) == true;
    },
  );
}

enum _Count { zero, one, more }
typedef _Id1CountResult = ({_Count normal, _Count backup, _Count haxAlike});

class _Id1CheckResult {
  late final List<Directory> normalFolders;
  late final List<Directory> backupFolders;
  late final List<Directory> haxAlikeFolders;
  _Id1CheckResult({
    List<Directory>? normalFolders,
    List<Directory>? backupFolders,
    List<Directory>? haxAlikeFolders,
  }) {
    this.normalFolders = normalFolders ?? [];
    this.backupFolders = backupFolders ?? [];
    this.haxAlikeFolders = haxAlikeFolders ?? [];
  }
  int get normalCount => normalFolders.length;
  int get backupCount => backupFolders.length;
  int get haxAlikeCount => haxAlikeFolders.length;
  Directory get normal {
    if (normalCount != 1) throw const MultipleSomeId1Exception();
    return normalFolders.first;
  }
  Directory get backup {
    if (backupCount != 1) throw const MultipleSomeId1Exception();
    return backupFolders.first;
  }
  Directory get haxAlike {
    if (haxAlikeCount != 1) throw const MultipleSomeId1Exception();
    return haxAlikeFolders.first;
  }
  static countResult(int count) => switch (count) {
    0 => _Count.zero,
    1 => _Count.one,
    _ => _Count.more, // negative also falls here... but that shouldn't happen
  };
  _Id1CountResult get allCountResult => (
    normal: countResult(normalCount),
    backup: countResult(backupCount),
    haxAlike: countResult(haxAlikeCount),
  );
}

class FolderAssignmentException implements Exception {
  final HaxAlertType type;
  final int count; // for multiple folder exceptions
  const FolderAssignmentException(this.type, [this.count = 0]);
}

class MultipleSomeId1Exception implements Exception {
  const MultipleSomeId1Exception();
}
