// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RootCheckList _$RootCheckListFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['update', 'src', 'checks'],
  );
  return RootCheckList(
    (json['update'] as num).toInt(),
    (json['src'] as List<dynamic>)
        .map((e) => const _UriConverter().fromJson(e as String))
        .toList(),
    RootCheckList._checksFromJson(json['checks'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RootCheckListToJson(RootCheckList instance) =>
    <String, dynamic>{
      'update': instance.update,
      'src': instance.src.map(const _UriConverter().toJson).toList(),
      'checks': instance.checks,
    };

SDRootFile _$SDRootFileFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['type', 'hash', 'src'],
  );
  return SDRootFile(
    $enumDecode(_$SDRootFileTypeEnumMap, json['type']),
    (json['hash'] as List<dynamic>)
        .map((e) => const _HexConverter().fromJson(e as String))
        .toList(),
    (json['src'] as List<dynamic>)
        .map((e) => const _UriConverter().fromJson(e as String))
        .toList(),
    json['info'] == null
        ? null
        : ArchiveInfo.fromJson(json['info'] as Map<String, dynamic>),
    json['localOnly'] as bool? ?? false,
  );
}

Map<String, dynamic> _$SDRootFileToJson(SDRootFile instance) =>
    <String, dynamic>{
      'type': _$SDRootFileTypeEnumMap[instance.type]!,
      'hash': instance.hash.map(const _HexConverter().toJson).toList(),
      'src': instance.src.map(const _UriConverter().toJson).toList(),
      'info': instance.info,
      'localOnly': instance.localOnly,
    };

const _$SDRootFileTypeEnumMap = {
  SDRootFileType.archive: 'archive',
  SDRootFileType.link: 'link',
  SDRootFileType.mset9: 'mset9',
  SDRootFileType.essential: 'essential',
  SDRootFileType.recommended: 'recommended',
};

ArchiveInfo _$ArchiveInfoFromJson(Map<String, dynamic> json) => ArchiveInfo(
      size: (json['size'] as num?)?.toInt(),
      sha256: _$JsonConverterFromJson<String, Uint8List>(
          json['sha256'], const _HexConverter().fromJson),
      md5: _$JsonConverterFromJson<String, Uint8List>(
          json['md5'], const _HexConverter().fromJson),
      update: const _DateTimeConverter().fromJson(json['update']),
    );

Map<String, dynamic> _$ArchiveInfoToJson(ArchiveInfo instance) =>
    <String, dynamic>{
      'size': instance.size,
      'sha256': _$JsonConverterToJson<String, Uint8List>(
          instance.sha256, const _HexConverter().toJson),
      'md5': _$JsonConverterToJson<String, Uint8List>(
          instance.md5, const _HexConverter().toJson),
      'update': _$JsonConverterToJson<dynamic, DateTime>(
          instance.update, const _DateTimeConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
