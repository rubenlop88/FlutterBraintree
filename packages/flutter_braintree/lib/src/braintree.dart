import 'package:flutter_braintree_platform_interface/flutter_braintree_platform_interface.dart';
import 'package:flutter_braintree_platform_interface/types/request.dart';
import 'package:flutter_braintree_platform_interface/types/result.dart';

class Braintree {
  const Braintree._();

  static Future<BraintreePaymentMethodNonce?> tokenizeCreditCard(
    String authorization,
    BraintreeCreditCardRequest request,
  ) =>
      FlutterBraintreePlatform.instance
          .tokenizeCreditCard(authorization, request);

  static Future<BraintreePaymentMethodNonce?> requestPaypalNonce(
    String authorization,
    BraintreePayPalRequest request,
  ) =>
      FlutterBraintreePlatform.instance
          .requestPaypalNonce(authorization, request);

  static Future<BraintreePaymentMethodNonce?> requestThreeDSNonce(
    String authorization,
    BraintreeThreeDSecureRequest request,
  ) =>
      FlutterBraintreePlatform.instance
          .requestThreeDSNonce(authorization, request);

  static Future<BraintreeDeviceData?> requestDeviceData(
    String authorization,
  ) =>
      FlutterBraintreePlatform.instance.requestDeviceData(authorization);

  static Future<BraintreeDeviceData?> requestPayPalDeviceData(
    String authorization,
  ) =>
      FlutterBraintreePlatform.instance.requestPayPalDeviceData(authorization);

  static Future<bool> canMakePaymentsWithApplePay() =>
      FlutterBraintreePlatform.instance.canMakePaymentsWithApplePay();

  static Future<BraintreePaymentMethodNonce?> requestApplePayPayment(
    String authorization,
    BraintreeApplePayRequest request,
  ) =>
      FlutterBraintreePlatform.instance
          .requestApplePayPayment(authorization, request);

  static Future<bool> canMakePaymentsWithGooglePay(String? authorization) =>
      FlutterBraintreePlatform.instance
          .canMakePaymentsWithGooglePay(authorization);

  static Future<BraintreePaymentMethodNonce?> requestGooglePayPayment(
    String authorization,
    BraintreeGooglePaymentRequest request,
  ) =>
      FlutterBraintreePlatform.instance
          .requestGooglePayPayment(authorization, request);
}
