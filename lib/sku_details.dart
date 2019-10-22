
import 'package:json_annotation/json_annotation.dart';

///
/// Represents an in-app product's listing details.
///
part 'sku_details.g.dart';

@JsonSerializable()
 class SkuDetails {
  final String mItemType;
  final String mSku;
  final String mType;
  final String mPrice;
  final String mTitle;
  final String mDescription;
  final String mJson;

  SkuDetails(this.mItemType, this.mSku, this.mType, this.mPrice, this.mTitle, this.mDescription, this.mJson);
  factory SkuDetails.fromJson(Map<String, dynamic> json) => _$SkuDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$SkuDetailsToJson(this);
}
