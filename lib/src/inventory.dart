/// Copyright (c) 2012 Google Inc.
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///     http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///

import 'package:cafebazaar_iab/src/purchase.dart';
import 'package:cafebazaar_iab/src/sku_details.dart';
import 'package:json_annotation/json_annotation.dart';

///
/// Represents a block of information about in-app items.
/// An Inventory is returned by such methods as {@link IabHelper#queryInventory}.
///
part 'inventory.g.dart';

@JsonSerializable()
class Inventory {
  final Map<String, SkuDetails> mSkuMap;
  final Map<String, Purchase> mPurchaseMap ;

  Inventory(this.mSkuMap, this.mPurchaseMap);

  ///
  /// Returns the listing details for an in-app product.
  ///
  SkuDetails getSkuDetails(String sku) {
    return mSkuMap[sku];
  }

  //// Returns purchase information for a given product, or null if there is no purchase.////
  Purchase getPurchase(String sku) {
    return mPurchaseMap[sku];
  }

  ///
  /// Returns whether or not there exists a purchase of the given product.
  ///
  bool hasPurchase(String sku) {
    return mPurchaseMap.containsKey(sku);
  }

  ///
  /// Return whether or not details about the given product are available.
  ///
  bool hasDetails(String sku) {
    return mSkuMap.containsKey(sku);
  }

  ///
  /// Erase a purchase (locally) from the inventory, given its product ID. This just
  /// modifies the Inventory object locally and has no effect on the server! This is
  /// useful when you have an existing Inventory object which you know to be up to date,
  /// and you have just consumed an item successfully, which means that erasing its
  /// purchase data from the Inventory you already have is quicker than querying for
  /// a new Inventory.
  ///
  void erasePurchase(String sku) {
    if (mPurchaseMap.containsKey(sku)) mPurchaseMap.remove(sku);
  }

  ///
  /// Returns a list of all owned product IDs.
  ///
  List<String> getAllOwnedSkus() {
    return mPurchaseMap.keys.toList(growable: false);
  }

  ///
  /// Returns a list of all owned product IDs of a given type
  ///
  List<String> getAllOwnedSkusWithItemType(String itemType) {
    return mPurchaseMap.values
        .where((p) => p.mItemType == itemType)
        .map((p) => p.mSku)
        .toList();
  }

  ///
  /// Returns a list of all purchases.
  ///
  List<Purchase> getAllPurchases() {
    return mPurchaseMap.values.toList(growable: false);
  }

  void addSkuDetails(SkuDetails d) {
    mSkuMap.putIfAbsent(d.mSku, () => d);
  }

  void addPurchase(Purchase p) {
    mPurchaseMap.putIfAbsent(p.mSku, () => p);
  }

  factory Inventory.fromJson(Map<String, dynamic> json) => _$InventoryFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryToJson(this);

}
