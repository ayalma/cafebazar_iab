import 'dart:async';
import 'dart:convert';

import 'package:cafebazaar_iab/cafebazaar_iab.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _publicKey =
      "";

  @override
  void initState() {
    super.initState();
    var subscription = CafebazaarIab().queryInventoryResult.listen((data){
      data
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<Resource<IabResult>>(
                stream: CafebazaarIab().initResult,
                builder: (context, snapshot) {
                  var isLoading = false;
                  var resource = snapshot.data;
                  if (snapshot.hasData) {
                    switch (resource.status) {
                      case Status.Loading:
                        isLoading = true;
                        break;
                      case Status.Error:
                        isLoading = false;
                        break;
                      case Status.Success:
                        isLoading = false;
                        break;
                    }
                  } else if (snapshot.hasError) {}

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonTheme(
                      height: 50.0,
                      child: OutlineButton.icon(
                        shape: OutlineInputBorder(gapPadding: 16.0),
                        onPressed: (isLoading)
                            ? null
                            : () {
                                CafebazaarIab().init(_publicKey);
                              },
                        icon: (isLoading)
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(),
                              )
                            : Icon(Icons.shopping_basket),
                        label: Text("Purchase"),
                      ),
                    ),
                  );
                },
              ),
              RaisedButton(
                onPressed: () async {
                  CafebazaarIab()
                      .queryInventoryAsync(null, querySkuDetail: true);
                },
                child: Text("Query Inventory"),
              ),
              RaisedButton(
                onPressed: () async {
                  CafebazaarIab().launchPurchaseFlow("test", "payload");
                },
                child: Text("Buy"),
              ),
              RaisedButton(
                onPressed: () async {
                  CafebazaarIab().consumeAsync(inventory.getPurchase("test"),);
                },
                child: Text("Consume"),
              ),
              if (inventory != null)
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            inventory.mSkuMap.values.toList()[index].mJson,
                          ),
                        ),
                      );
                    },
                    itemCount: inventory.mSkuMap.length,
                  ),
                )
            ],
          ),
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
