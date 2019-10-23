import 'dart:async';
import 'dart:convert';

import 'package:cafebazaar_iab/src/iab_result.dart';
import 'package:cafebazaar_iab/src/inventory.dart';
import 'package:cafebazaar_iab/src/inventory_result.dart';
import 'package:cafebazaar_iab/src/purchase.dart';
import 'package:cafebazaar_iab/src/purchase_result.dart';
import 'package:cafebazaar_iab/src/resource.dart';
import 'package:flutter/services.dart';

import 'consume_multi_result.dart';
import 'consume_result.dart';

typedef OnConsumeMultiFinished = Future<dynamic> Function(
    List<IabResult> results, List<Purchase> purchases);

typedef OnConsumeFinished = Future<dynamic> Function(
    IabResult result, Purchase purchase);

class CafebazaarIab {
  static final CafebazaarIab _instance = CafebazaarIab._internal();

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

  StreamController<Resource<IabResult>> _initController =
      new StreamController();

  Stream<Resource<IabResult>> get initResult => _initController.stream;

  StreamController<Resource<InventoryResult>> _queryInventoryController =
      new StreamController();

  Stream<Resource<InventoryResult>> get queryInventoryResult =>
      _queryInventoryController.stream;

  StreamController<Resource<PurchaseResult>> _purchaseController =
      new StreamController();

  Stream<Resource<PurchaseResult>> get purchaseResult =>
      _purchaseController.stream;

  StreamController<Resource<ConsumeMultiResult>> _consumeMultiController =
      new StreamController();

  Stream<Resource<ConsumeMultiResult>> get consumeMultiResult =>
      _consumeMultiController.stream;

  StreamController<Resource<ConsumeResult>> _consumeController =
      new StreamController();

  Stream<Resource<ConsumeResult>> get consumeResult =>
      _consumeController.stream;

  CafebazaarIab._internal() {
    _channel = const MethodChannel(_CAFEBAZAAR_IAB);
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<bool> init(String base64EncodedPublicKey) async {
    _initController.add(Resource.loading());
    await Future.delayed(Duration(seconds: 2));
    return await _channel.invokeMethod<bool>(_INIT, [base64EncodedPublicKey]);
  }

  Future<bool> queryInventoryAsync(List<String> moreSku,
      {bool querySkuDetail = true}) async {
    _queryInventoryController.add(Resource.loading());
    return await _channel
        .invokeMethod(_QUERY_INVENTORY_ASYNC, [querySkuDetail, moreSku]);
  }

  Future<bool> launchPurchaseFlow(String sku, String payload) async {
    _purchaseController.add(Resource.loading());
    return await _channel.invokeMethod(_LAUNCH_PURCHASE_FLOW, [sku, payload]);
  }

  Future<bool> consumeMultiAsync(List<Purchase> purchases,
      OnConsumeMultiFinished onConsumeMultiFinished) async {
    _consumeMultiController.add(Resource.loading());
    return await _channel.invokeMethod(_CONSUME_MULTI_ASYNC,
        json.encode(purchases.map((purchase) => purchase.toJson()).toList()));
  }

  Future<bool> consumeAsync(
      Purchase purchase, OnConsumeFinished onConsumeFinished) async {
    _consumeController.add(Resource.loading());
    return await _channel.invokeMethod(
        _CONSUME_ASYNC, json.encode(purchase.toJson()));
  }

  Future<bool> dispose() {
    _initController.close();
    _queryInventoryController.close();
    _consumeMultiController.close();
    _consumeController.close();
    _purchaseController.close();

    return _channel.invokeMethod<bool>(_DISPOSE);
  }

  Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _ON_IAB_SETUP_FINISHED:
        var test = IabResult.fromJson(json.decode(call.arguments));
        _initController.add(Resource.success(test));
        break;
      case _QUERY_INVENTORY_FINISHED:
        var result = IabResult.fromJson(json.decode(call.arguments[0]));
        var inventory;
        if (call.arguments[1] != null)
          inventory = Inventory.fromJson(json.decode(call.arguments[1]));

        _queryInventoryController
            .add(Resource.success(InventoryResult(result, inventory)));
        break;

      case _ON_IAB_PURCHASE_FINISHED:
        var result = IabResult.fromJson(json.decode(call.arguments[0]));
        var purchase;
        if (call.arguments[1] != null)
          purchase = Purchase.fromJson(json.decode(call.arguments[1]));
        _purchaseController
            .add(Resource.success(PurchaseResult(result, purchase)));
        break;

      case _ON_CONSUME_MULTI_FINISHED:
        var resultsIterable =
            json.decode(call.arguments[0]) as Iterable<Map<String, dynamic>>;
        var results =
            resultsIterable.map((item) => IabResult.fromJson(item)).toList();

        var purchases = List(0);
        if (call.arguments[1] != null) {
          var purchasesIterable =
              json.decode(call.arguments[1]) as Iterable<Map<String, dynamic>>;
          purchases =
              purchasesIterable.map((item) => Purchase.fromJson(item)).toList();
        }
        _consumeMultiController
            .add(Resource.success(ConsumeMultiResult(results, purchases)));
        break;

      case _ON_CONSUME_FINISHED:
        var result = IabResult.fromJson(json.decode(call.arguments[0]));

        var purchase;
        if (call.arguments[1] != null)
          purchase = Purchase.fromJson(json.decode(call.arguments[1]));

        _consumeController
            .add(Resource.success(ConsumeResult(result, purchase)));
        break;
      default:
        return Future.error('method not defined');
    }
  }
}
