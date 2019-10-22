// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inventory _$InventoryFromJson(Map<String, dynamic> json) {
  return Inventory(
      (json['mSkuMap'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(k,
            e == null ? null : SkuDetails.fromJson(e as Map<String, dynamic>)),
      ),
      (json['mPurchaseMap'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(
            k, e == null ? null : Purchase.fromJson(e as Map<String, dynamic>)),
      ));
}

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      'mSkuMap': instance.mSkuMap,
      'mPurchaseMap': instance.mPurchaseMap
    };
