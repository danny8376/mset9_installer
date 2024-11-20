const kOldId1Suffix = "_user-id1";
const kTriggerFile = "002F003A.txt"; // ":/"

const kN3dsFolder = "Nintendo 3DS";

final kId0Regex = RegExp(r"^(?![0-9a-fA-F]{4}(01|00)[0-9a-fA-F]{18}00[0-9a-fA-F]{6})[0-9a-fA-F]{32}$");
final kId1Regex = RegExp("^[0-9a-fA-F]{32}(?:$kOldId1Suffix)?\$");

final kFirmBakRegex = RegExp(r"^firm\d_enc\.bak$");
