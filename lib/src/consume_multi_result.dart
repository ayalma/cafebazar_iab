import '../cafebazaar_iab.dart';

class ConsumeMultiResult {
  final List<IabResult> results;
  final List<Purchase> purchases;

  ConsumeMultiResult(this.results, this.purchases);
}
