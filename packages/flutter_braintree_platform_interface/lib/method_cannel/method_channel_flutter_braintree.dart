import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_braintree_platform_interface/flutter_braintree_platform_interface.dart';
import 'package:flutter_braintree_platform_interface/types/request.dart';
import 'package:flutter_braintree_platform_interface/types/result.dart';

const MethodChannel _kCustomChannel = MethodChannel('flutter_braintree.custom');
const MethodChannel _kDropInChannel =
    MethodChannel('flutter_braintree.drop_in');

/// An implementation of [FlutterBraintreePlatform] that uses method channels.
class MethodChannelFlutterBraintree extends FlutterBraintreePlatform {
  @override
  Future<BraintreePaymentMethodNonce?> tokenizeCreditCard(
    String authorization,
    BraintreeCreditCardRequest request,
  ) async {
    final result = await _kCustomChannel.invokeMethod('tokenizeCreditCard', {
      'authorization': authorization,
      'request': request.toJson(),
    });
    return BraintreePaymentMethodNonce.fromJson(result);
  }

  @override
  Future<BraintreePaymentMethodNonce?> requestPaypalNonce(
    String authorization,
    BraintreePayPalRequest request,
  ) async {
    final result = await _kCustomChannel.invokeMethod('requestPaypalNonce', {
      'authorization': authorization,
      'request': request.toJson(),
    });
    return BraintreePaymentMethodNonce.fromJson(result);
  }

  @override
  Future<BraintreePaymentMethodNonce?> requestThreeDSNonce(
    String authorization,
    BraintreeThreeDSecureRequest request,
  ) async {
    final result = await _kCustomChannel.invokeMethod('threeDSecure', {
      'authorization': authorization,
      'request': request.toMap(),
    });
    return BraintreePaymentMethodNonce.fromJson(result);
  }

  @override
  Future<BraintreeDeviceData?> requestDeviceData(
    String authorization,
  ) async {
    final result = await _kCustomChannel.invokeMethod('requestDeviceData', {
      'authorization': authorization,
    });

    return BraintreeDeviceData.fromJson(result);
  }

  @override
  Future<BraintreeDeviceData?> requestPayPalDeviceData(
    String authorization,
  ) async {
    final result =
        await _kCustomChannel.invokeMethod('requestPayPalDeviceData', {
      'authorization': authorization,
    });

    return BraintreeDeviceData.fromJson(result);
  }

  @override
  Future<bool> canMakePaymentsWithApplePay() async {
    final result =
        await _kCustomChannel.invokeMethod('canMakePaymentsWithApplePay');
    final BraintreeCanMakePaymentsResult? brainTreeCanMakePaymentsResult =
        BraintreeCanMakePaymentsResult.fromJson(result);

    return brainTreeCanMakePaymentsResult != null &&
        brainTreeCanMakePaymentsResult.canMakePayments;
  }

  @override
  Future<BraintreePaymentMethodNonce?> requestApplePayPayment(
    String authorization,
    BraintreeApplePayRequest request,
  ) async {
    final result =
        await _kCustomChannel.invokeMethod('requestApplePayPayment', {
      'authorization': authorization,
      'request': request.toJson(),
    });
    return BraintreePaymentMethodNonce.fromJson(result);
  }

  @override
  Future<bool> canMakePaymentsWithGooglePay(String? authorization) async {
    final result =
        await _kCustomChannel.invokeMethod('canMakePaymentsWithGooglePay', {
      if (authorization != null) 'authorization': authorization,
    });

    return BraintreeCanMakePaymentsResult.fromJson(result)?.canMakePayments ??
        false;
  }

  @override
  Future<BraintreePaymentMethodNonce?> requestGooglePayPayment(
    String authorization,
    BraintreeGooglePaymentRequest request,
  ) async {
    final result =
        await _kCustomChannel.invokeMethod('requestGooglePayPayment', {
      'authorization': authorization,
      'request': request.toJson(),
    });
    return BraintreePaymentMethodNonce.fromJson(result);
  }

  @override
  Future<BraintreeDropInResult?> start(BraintreeDropInRequest request) async {
    var result = await _kDropInChannel.invokeMethod(
      'start',
      request.toJson(),
    );
    return BraintreeDropInResult.fromJson(result);
  }
}
