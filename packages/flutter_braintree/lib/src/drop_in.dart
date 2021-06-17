import 'dart:async';

import 'package:flutter/services.dart';

class BraintreeDropIn {
  static const MethodChannel _kChannel =
      const MethodChannel('flutter_braintree.drop_in');

  const BraintreeDropIn._();

  static Future<BraintreeDropInResult?> start(
      BraintreeDropInRequest request) async {
    var result = await _kChannel.invokeMethod(
      'start',
      request.toJson(),
    );
    return BraintreeDropInResult.fromJson(result);
  }
}
