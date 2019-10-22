// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iab_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IabResult _$IabResultFromJson(Map<String, dynamic> json) {
  return IabResult(json['mResponse'] as int, json['mMessage'] as String);
}

Map<String, dynamic> _$IabResultToJson(IabResult instance) => <String, dynamic>{
      'mResponse': instance.response,
      'mMessage': instance.message
    };
