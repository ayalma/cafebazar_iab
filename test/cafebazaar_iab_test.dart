import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cafebazaar_iab/src/cafebazaar_iab.dart';

void main() {
  const MethodChannel channel = MethodChannel('cafebazar_iab');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await CafebazaarIab().init(""), '42');
  });
}
