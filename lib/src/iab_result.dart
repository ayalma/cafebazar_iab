import 'package:json_annotation/json_annotation.dart';
part 'iab_result.g.dart';

@JsonSerializable()
class IabResult {
  static final int _BILLING_RESPONSE_RESULT_OK = 0;
  static final int _BILLING_RESPONSE_RESULT_USER_CANCELED = 1;
  static final int _BILLING_RESPONSE_RESULT_BILLING_UNAVAILABLE = 3;

  @JsonKey(name: "mResponse")
  final int response;
  @JsonKey(name: "mMessage")
  final String message;

  IabResult(this.response, this.message);

  bool isSuccess() {
    return response == _BILLING_RESPONSE_RESULT_OK;
  }

  bool isFailure() {
    return !isSuccess();
  }

  factory IabResult.fromJson(Map<String, dynamic> json) => _$IabResultFromJson(json);

  Map<String, dynamic> toJson() => _$IabResultToJson(this);
}
