import 'dart:typed_data';

// modified from: https://stackoverflow.com/a/70751501/2839771
bool typedDataEquals(TypedData? typedData1, TypedData? typedData2) {
  if (typedData1 == null || typedData2 == null) {
    return false;
  }
  if (identical(typedData1, typedData2)) {
    return true;
  }

  if (typedData1.lengthInBytes != typedData2.lengthInBytes) {
    return false;
  }

  // Treat the original byte lists as lists of 8-byte words.
  final numWords = typedData1.lengthInBytes ~/ 8;
  final words1 = typedData1.buffer.asUint64List(0, numWords);
  final words2 = typedData2.buffer.asUint64List(0, numWords);

  for (var i = 0; i < words1.length; i += 1) {
    if (words1[i] != words2[i]) {
      return false;
    }
  }

  // Compare any remaining bytes.
  final bytes1 = typedData1.buffer.asUint8List();
  final bytes2 = typedData1.buffer.asUint8List();
  for (var i = words1.lengthInBytes; i < bytes1.lengthInBytes; i += 1) {
    if (bytes1[i] != bytes2[i]) {
      return false;
    }
  }

  return true;
}
