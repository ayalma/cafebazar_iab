import 'dart:async';
import 'dart:convert';

import 'package:cafebazaar_iab/iab_result.dart';
import 'package:cafebazaar_iab/purchase.dart';
import 'package:flutter/services.dart';

import 'inventory.dart';

typedef OnIabSetupFinished = Future<dynamic> Function(IabResult result);
typedef OnQueryInventoryFinished = Future<dynamic> Function(
    IabResult result, Inventory inventory);

typedef OnIabPurchaseFinished = Future<dynamic> Function(
    IabResult result, Purchase info);

typedef OnConsumeMultiFinished = Future<dynamic> Function(
    List<IabResult> results, List<Purchase> purchases);

typedef OnConsumeFinished = Future<dynamic> Function(
    IabResult result, Purchase purchase);

class CafebazaarIab {
  static final CafebazaarIab _instance = CafebazaarIab.internal();

  static const String _CAFEBAZAAR_IAB = "cafebazaar_iab";
  static const String _INIT = "cb_iab_init";
  static const String _DISPOSE = "cb_iab_dispose";
  static const String _ON_IAB_SETUP_FINISHED = "cb_iab_onIabSetupFinished";
  static const String _QUERY_INVENTORY_ASYNC = "cb_iab_queryInventoryAsync";
  static const String _QUERY_INVENTORY_FINISHED =
      "cb_iab_onQueryInventoryFinished";

  static const String _LAUNCH_PURCHASE_FLOW = "cb_iab_launchPurchaseFlow";
  static const String _ON_IAB_PURCHASE_FINISHED =
      "cb_iab_onIabPurchaseFinished";

  static const String _CONSUME_MULTI_ASYNC = "cb_iab_consumeMultiAsync";
  static const String _ON_CONSUME_MULTI_FINISHED =
      "cb_iab_OnConsumeMultiFinishedListener";

  static const String _CONSUME_ASYNC = "cb_iab_consumeAsync";
  static const String _ON_CONSUME_FINISHED = "cb_iab_OnConsumeFinishedListener";

  factory CafebazaarIab() => _instance;

  MethodChannel _channel;
  OnIabSetupFinished _iabSetupFinished;
  OnQueryInventoryFinished _onQueryInventoryFinished;
  OnIabPurchaseFinished _onIabPurchaseFinished;
  OnConsumeMultiFinished _onConsumeMultiFinished;
  OnConsumeFinished _onConsumeFinished;

  CafebazaarIab.internal() {
    _channel = const MethodChannel(_CAFEBAZAAR_IAB);
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<bool> init(OnIabSetupFinished iabSetupFinished,
      String base64EncodedPublicKey) async {
    _iabSetupFinished = iabSetupFinished;
    return await _channel.invokeMethod<bool>(_INIT, [base64EncodedPublicKey]);
  }

  Future<bool> queryInventoryAsync(
      OnQueryInventoryFinished onQueryInventoryFinished, List<String> moreSku,
      {bool querySkuDetail = true}) async {
    _onQueryInventoryFinished = onQueryInventoryFinished;
    return await _channel
        .invokeMethod(_QUERY_INVENTORY_ASYNC, [querySkuDetail, moreSku]);
  }

  Future<bool> launchPurchaseFlow(String sku, String payload,
      OnIabPurchaseFinished onIabPurchaseFinished) async {
    _onIabPurchaseFinished = onIabPurchaseFinished;
    return await _channel.invokeMethod(_LAUNCH_PURCHASE_FLOW, [sku, payload]);
  }

  Future<bool> consumeMultiAsync(List<Purchase> purchases,OnConsumeMultiFinished onConsumeMultiFinished)async {
    _onConsumeMultiFinished = onConsumeMultiFinished;
    return await _channel.invokeMethod(_CONSUME_MULTI_ASYNC,json.encode(purchases.map((purchase)=>purchase.toJson()).toList()));
  }

  Future<bool> consumeAsync(Purchase purchase,OnConsumeFinished onConsumeFinished) async{
    _onConsumeFinished = onConsumeFinished;
    return await _channel.invokeMethod(_CONSUME_ASYNC,json.encode(purchase.toJson()));
  }

  Future<bool> dispose() {
    return _channel.invokeMethod<bool>(_DISPOSE);
  }

  Future<void> _handleMethod(MethodCall call) {
    switch (call.method) {
      case _ON_IAB_SETUP_FINISHED:
        var test = IabResult.fromJson(json.decode(call.arguments));
        return _iabSetupFinished(test);
      case _QUERY_INVENTORY_FINISHED:
        var result = IabResult.fromJson(json.decode(call.arguments[0]));
        var invJson;
        if (call.arguments[1] != null)
          invJson = Inventory.fromJson(json.decode(call.arguments[1]));
        return _onQueryInventoryFinished(result, invJson);
      case _ON_IAB_PURCHASE_FINISHED:
        var result = IabResult.fromJson(json.decode(call.arguments[0]));
        var purchase;
        if (call.arguments[1] != null)
          purchase = Purchase.fromJson(json.decode(call.arguments[1]));
        return _onIabPurchaseFinished(result, purchase);
        break;

      case _ON_CONSUME_MULTI_FINISHED:

        var resultsIterable = json.decode(call.arguments[0]) as Iterable<Map<String,dynamic>>;
        var results = resultsIterable.map((item)=>IabResult.fromJson(item)).toList();

        var purchases = List(0);
        if (call.arguments[1] != null) {
          var purchasesIterable = json.decode(call.arguments[1]) as Iterable<Map<String,dynamic>>;
          purchases = purchasesIterable.map((item)=>Purchase.fromJson(item)).toList();
        }

        return _onConsumeMultiFinished(results,purchases);

      case _ON_CONSUME_FINISHED:
        var result = IabResult.fromJson(json.decode(call.arguments[0]));

        var purchase;
        if (call.arguments[1] != null)
          purchase = Purchase.fromJson(json.decode(call.arguments[1]));

        return _onConsumeFinished(result,purchase);
      default:
        return Future.error('method not defined');
    }
  }
}
