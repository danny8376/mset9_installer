import 'dart:typed_data';
import 'dart:html'; // ignore: avoid_web_libraries_in_flutter

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

  return window.indexedDB!.cmp(typedData1, typedData2) == 0;
}
