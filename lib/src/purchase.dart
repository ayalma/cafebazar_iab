import 'package:json_annotation/json_annotation.dart';

part 'purchase.g.dart';

@JsonSerializable()
class Purchase{
  final String mItemType;  // ITEM_TYPE_INAPP or ITEM_TYPE_SUBS
  final String mOrderId;
  final String mPackageName;
  final String mSku;
  final int mPurchaseTime;
  final int mPurchaseState;
  final String mDeveloperPayload;
  final String mToken;
  final String mOriginalJson;
  final String mSignature;

  Purchase(this.mItemType, this.mOrderId, this.mPackageName, this.mSku, this.mPurchaseTime, this.mPurchaseState, this.mDeveloperPayload, this.mToken, this.mOriginalJson, this.mSignature);
  factory Purchase.fromJson(Map<String, dynamic> json) => _$PurchaseFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseToJson(this);
}