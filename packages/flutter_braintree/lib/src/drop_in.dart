import 'dart:async';

import 'package:flutter_braintree_platform_interface/flutter_braintree_platform_interface.dart';
import 'package:flutter_braintree_platform_interface/types/request.dart';
import 'package:flutter_braintree_platform_interface/types/result.dart';

class BraintreeDropIn {
  const BraintreeDropIn._();

  static Future<BraintreeDropInResult?> start(BraintreeDropInRequest request) =>
      FlutterBraintreePlatform.instance.start(request);
}
