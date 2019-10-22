import 'dart:async';
import 'dart:convert';

import 'package:cafebazaar_iab/cafebazaar_iab.dart';
import 'package:cafebazaar_iab/inventory.dart';
import 'package:cafebazaar_iab/purchase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _publicKey =
      "cafebazar public key";

  Inventory inventory;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await CafebazaarIab().init(
        (res) {
          setState(() {
            _platformVersion = res.message;
          });
          print(res);
          return Future.value(true);
        },
        _publicKey,
      ))
          .toString();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),

            RaisedButton(
              onPressed: () async {
                CafebazaarIab().queryInventoryAsync((result,inv){
                  print(json.encode(inv.toJson()));
                  setState(() {
                    inventory = inv;
                  });
                  return Future.value(true);
                },null,querySkuDetail: true);
              },
              child: Text("Query Inventory"),
            ),
            RaisedButton(
              onPressed: () async {
                CafebazaarIab().launchPurchaseFlow("test","payload",(result,info){
                  print(json.encode(result.toJson()));
                  return Future.value(true);
                });
              },
              child: Text("Buy"),
            ),
            RaisedButton(
              onPressed: () async {
                CafebazaarIab().consumeAsync(inventory.getPurchase("test"),(result,info){
                  print(json.encode(result.toJson()));
                  return Future.value(true);
                });
              },
              child: Text("Consume"),
            ),
            if(inventory!=null)
            Expanded(
              child: ListView.builder(itemBuilder: (context,index){
                return ListTile(title: Text(inventory.mSkuMap.values.toList()[index].mDescription),);
              },itemCount: inventory.mSkuMap.length,),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async {
    await CafebazaarIab().dispose();
    super.dispose();
  }
}
