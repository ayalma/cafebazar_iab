// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Purchase _$PurchaseFromJson(Map<String, dynamic> json) {
  return Purchase(
      json['mItemType'] as String,
      json['mOrderId'] as String,
      json['mPackageName'] as String,
      json['mSku'] as String,
      json['mPurchaseTime'] as int,
      json['mPurchaseState'] as int,
      json['mDeveloperPayload'] as String,
      json['mToken'] as String,
      json['mOriginalJson'] as String,
      json['mSignature'] as String);
}

Map<String, dynamic> _$PurchaseToJson(Purchase instance) => <String, dynamic>{
      'mItemType': instance.mItemType,
      'mOrderId': instance.mOrderId,
      'mPackageName': instance.mPackageName,
      'mSku': instance.mSku,
      'mPurchaseTime': instance.mPurchaseTime,
      'mPurchaseState': instance.mPurchaseState,
      'mDeveloperPayload': instance.mDeveloperPayload,
      'mToken': instance.mToken,
      'mOriginalJson': instance.mOriginalJson,
      'mSignature': instance.mSignature
    };
