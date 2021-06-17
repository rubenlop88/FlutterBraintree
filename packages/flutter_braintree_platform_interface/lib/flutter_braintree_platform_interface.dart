import 'dart:async';

import 'package:flutter_braintree_platform_interface/method_cannel/method_channel_flutter_braintree.dart';
import 'package:flutter_braintree_platform_interface/types/request.dart';
import 'package:flutter_braintree_platform_interface/types/result.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of flutter_braintree must implement.
///
/// Platform implementations should extend this class rather than implement it as `flutter_braintree`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [FlutterBraintreePlatform] methods.
abstract class FlutterBraintreePlatform extends PlatformInterface {
  /// Constructs a UrlLauncherPlatform.
  FlutterBraintreePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBraintreePlatform _instance = MethodChannelFlutterBraintree();

  /// The default instance of [FlutterBraintreePlatform] to use.
  ///
  /// Defaults to [MethodChannelUrlLauncher].
  static FlutterBraintreePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlutterBraintreePlatform] when they register themselves.
  static set instance(FlutterBraintreePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Custom methods
  ///  /// Tokenizes a credit card.
  ///
  /// [authorization] must be either a valid client token or a valid tokenization key.
  /// [request] should contain all the credit card information necessary for tokenization.
  ///
  /// Returns a [Future] that resolves to a [BraintreePaymentMethodNonce] if the tokenization was successful.
  Future<BraintreePaymentMethodNonce?> tokenizeCreditCard(
    String authorization,
    BraintreeCreditCardRequest request,
  ) {
    throw UnimplementedError('tokenizeCreditCard() has not been implemented.');
  }

  /// Requests a PayPal payment method nonce.
  ///
  /// [authorization] must be either a valid client token or a valid tokenization key.
  /// [request] should contain all the information necessary for the PayPal request.
  ///
  /// Returns a [Future] that resolves to a [BraintreePaymentMethodNonce] if the user confirmed the request,
  /// or `null` if the user canceled the Vault or Checkout flow.
  Future<BraintreePaymentMethodNonce?> requestPaypalNonce(
    String authorization,
    BraintreePayPalRequest request,
  ) {
    throw UnimplementedError('requestPaypalNonce() has not been implemented.');
  }

  Future<BraintreePaymentMethodNonce?> requestThreeDSNonce(
    String authorization,
    BraintreeThreeDSecureRequest request,
  ) {
    throw UnimplementedError('requestThreeDSNonce() has not been implemented.');
  }

  Future<BraintreeDeviceData?> requestDeviceData(
    String authorization,
  ) {
    throw UnimplementedError('requestDeviceData() has not been implemented.');
  }

  Future<BraintreeDeviceData?> requestPayPalDeviceData(
    String authorization,
  ) {
    throw UnimplementedError(
        'requestPayPalDeviceData() has not been implemented.');
  }

  Future<bool> canMakePaymentsWithApplePay() {
    throw UnimplementedError(
        'canMakePaymentsWithApplePay() has not been implemented.');
  }

  Future<BraintreePaymentMethodNonce?> requestApplePayPayment(
    String authorization,
    BraintreeApplePayRequest request,
  ) {
    throw UnimplementedError(
        'requestApplePayPayment() has not been implemented.');
  }

  Future<bool> canMakePaymentsWithGooglePay(String? authorization) {
    throw UnimplementedError(
        'canMakePaymentsWithGooglePay() has not been implemented.');
  }

  Future<BraintreePaymentMethodNonce?> requestGooglePayPayment(
    String authorization,
    BraintreeGooglePaymentRequest request,
  ) {
    throw UnimplementedError(
        'requestGooglePayPayment() has not been implemented.');
  }

  /// Drop in methods
  /// Launches the Braintree Drop-in UI.
  ///
  /// The required options can be placed inside the [request] object.
  /// See its documentation for more information.
  ///
  /// Returns a Future that resolves to a [BraintreeDropInResult] containing
  /// all the relevant information, or `null` if the selection was canceled.
  Future<BraintreeDropInResult?> start(BraintreeDropInRequest request) {
    throw UnimplementedError(
        'requestGooglePayPayment() has not been implemented.');
  }
}
