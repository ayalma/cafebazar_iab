// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sku_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkuDetails _$SkuDetailsFromJson(Map<String, dynamic> json) {
  return SkuDetails(
      json['mItemType'] as String,
      json['mSku'] as String,
      json['mType'] as String,
      json['mPrice'] as String,
      json['mTitle'] as String,
      json['mDescription'] as String,
      json['mJson'] as String);
}

Map<String, dynamic> _$SkuDetailsToJson(SkuDetails instance) =>
    <String, dynamic>{
      'mItemType': instance.mItemType,
      'mSku': instance.mSku,
      'mType': instance.mType,
      'mPrice': instance.mPrice,
      'mTitle': instance.mTitle,
      'mDescription': instance.mDescription,
      'mJson': instance.mJson
    };
