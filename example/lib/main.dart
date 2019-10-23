import 'package:cafebazaar_iab/cafebazaar_iab.dart';
import 'package:flutter/material.dart';

import 'main_bloc.dart';
import 'resource.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MainBloc _bloc = MainBloc();
  String _platformVersion = 'Unknown';

  Inventory inventory;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<Resource<IabResult>>(
                  stream: _bloc.setupResult,
                  builder: (context, snapshot) {
                    var isLoading = false;
                    if (snapshot.hasData) {
                      final resource = snapshot.data;
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
                    }
                    return AnimatedSwitcher(
                      child: (!isLoading)
                          ? OutlineButton.icon(
                              onPressed: () => _bloc.setup(),
                              icon: Icon(Icons.shopping_basket),
                              label: Text("Setup"),
                            )
                          : OutlineButton.icon(
                              onPressed: null,
                              icon: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(),
                              ),
                              label: Text("Setup"),
                            ),
                      duration: Duration(milliseconds: 2000),
                      reverseDuration: Duration(milliseconds: 700),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    _bloc.dispose();
    await CafebazaarIab().dispose();
    super.dispose();
  }
}
