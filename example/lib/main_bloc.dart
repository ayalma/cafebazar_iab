import 'dart:async';

import 'package:cafebazaar_iab/cafebazaar_iab.dart';

import 'resource.dart';

class MainBloc {
  String _publicKey =
      "";
  StreamController<Resource<IabResult>> _setupController = StreamController();
  Stream<Resource<IabResult>> get setupResult => _setupController.stream;

  void setup() {
    _setupController.add(Resource.loading());
    CafebazaarIab().init((result) async {
      await Future.delayed(Duration(seconds: 3));
      _setupController.add(Resource.success(result));
    }, _publicKey);
  }

  dispose() {
    _setupController.close();
  }
}
