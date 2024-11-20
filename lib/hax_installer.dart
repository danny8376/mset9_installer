import 'dart:async';

import 'console.dart';
import 'consts.dart';
import 'hax.dart';
import 'io.dart';
import 'io_utils.dart';
import 'root_check.dart';
import 'string_utils.dart';
import 'talker.dart';

enum HaxStage { pickFolder, folderPicked, /*pickVariant,*/ postSetup, readyToInject, doExploit, broken, doingWork }

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

  void Function(HaxStage) stageUpdateCallback;
  void Function(HaxAlertType) alertCallback;
  void Function(HaxConfirmationType, Future<bool> Function(bool), [dynamic]) confirmationCallback;

  HaxInstaller({
    required this.stageUpdateCallback,
    required this.alertCallback,
    required this.confirmationCallback,
  });

  HaxStage get stage => _stage;

  Variant? get variant => _variant;
  set variant(Variant? variant) {

  }

  Future<void> checkState({bool silent = false, bool skipSdRoot = false}) async {
    try {
      talker.debug("Common: Checking state");
      if (id0Folder == null) {
        stageUpdateCallback(_stage = HaxStage.pickFolder);
        return;
      }
      final matching = await _findHaxId1();
      if (matching != null) {
        id1HaxFolder = matching.folder;
        _variant = matching.hax.dummyVariant;
        checkInjectState(silent: silent, skipSdRoot: skipSdRoot);
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
    } catch (e, st) {
      talker.handle(e, st);
    }
  }

  Future<void> checkInjectState({bool silent = false, bool skipSdRoot = false}) async {
    try {
      talker.debug("Common: Checking inject state");
      if (id1HaxFolder == null) {
        return;
      }
      if (!skipSdRoot && await checkSDRootMissing(silent: silent, ignoreOptional: true) != null) {
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
    } catch (e, st) {
      talker.handle(e, st);
    }
  }

  Future<void> checkAndAssignFolders(Directory dir) async {
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
      checkState();
    } on FolderAssignmentException {
      rethrow;
    } catch (e, st) {
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
      }
      return await _pickId0FromN3DS();
    } else if (await _checkIfId0(dir)) {
      talker.debug("FolderPicking: Check: ID0 Folder Picked");
      id0Folder = dir;
      if (canAccessParentOfPicked) {
        n3dsFolder = id0Folder!.parent;
        sdRoot = n3dsFolder!.parent;
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
    bool switchStageToDoingWork = false,
    required Future<T> Function() work,
    Future<void> Function(T result)? done,
  }) async {
    if (switchStageToDoingWork) {
      stageUpdateCallback(_stage = HaxStage.doingWork);
    }
    T result = faultResult;
    try {
      result = await work();
    } catch (e, st) {
      talker.handle(e, st);
    }
    if (done != null) {
      await done(result);
    }
    return result;
  }

  Future<Map<String, CheckState>?> checkSDRootMissing({bool silent = false, bool ignoreOptional = false}) async {
    if (sdRoot == null) { // always pass when unable to check
      return null;
    }

    talker.debug("Setup: Checking SD root files...");
    var missing = await sdRootCheck(sdRoot!, loose: looseRootCheck);
    //talker.debug(missing);
    if (!silent && missing != null) {
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
          missing
      );
      if (await completer.future) {
        missing = await sdRootCheck(sdRoot!, loose: looseRootCheck);
      }
    }
    if (ignoreOptional) {
      missing?.removeWhere((k, v) => v.optional);
    }
    return missing?.isEmpty == true ? null : missing;
  }

  Future<bool> switchVariant(Variant variant) async {
    switch (_stage) {
      case HaxStage.pickFolder:
      //case HaxStage.folderPicked:
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
    done: (result) async {
      (result ? checkInjectState : checkState)(silent: true);
    },
  );

  Future<bool> setupSDRoot() => _exceptionGuard(
    faultResult: false,
    switchStageToDoingWork: true,
    work: () async {
      if (sdRoot == null) {
        return true;
      }
      final missing = await checkSDRootMissing(silent: true);
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
      await downloadSdRootFiles(sdRoot!, fileList: fileList.toList(growable: false));
      final verify = await checkSDRootMissing(silent: true);
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
    work: () async =>
        await (await id1HaxExtdataFolder?.file(kTriggerFile, create: true))?.writeAsBytes([], flush: true) != null,
    done: (result) async {
      checkInjectState(skipSdRoot: true);
    }
  );

  Future<bool> removeTrigger() => _exceptionGuard(
    faultResult: false,
    switchStageToDoingWork: false,
    work: () async => await (await id1HaxExtdataFolder?.file(kTriggerFile))?.delete() != null,
    done: (result) async {
      checkInjectState(skipSdRoot: true);
    },
  );

  Future<bool> removeHaxId1() => _exceptionGuard(
    faultResult: false,
    switchStageToDoingWork: true,
    work: () async {
      talker.debug("Setup: Remove - ${_variant?.model} ${_variant?.version.major}.${_variant?.version.minor}");
      await (await _findHaxFolder())?.delete(recursive: true);
      final backupId1 = await _findBackupId1();
      await backupId1?.renameInplace(backupId1.name.replaceAll(kOldId1Suffix, ''));
      return true;
    },
    done: (result) async {
      _variant = null;
      checkState(silent: true, skipSdRoot: true);
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
