@JS()
library braintree_web_client;

import 'package:flutter_braintree_platform_interface/flutter_braintree_platform_interface.dart';
import 'package:flutter_braintree_platform_interface/types/request.dart';
import 'package:flutter_braintree_platform_interface/types/result.dart';
import 'package:flutter_braintree_web/classes/client.dart' as client_package;
import 'package:flutter_braintree_web/classes/data_collector.dart'
    as data_collector_package;
import 'package:flutter_braintree_web/classes/paypal.dart' as paypal_package;
import 'package:flutter_braintree_web/classes/three_d_secure.dart'
    as three_d_secure_package;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

class FlutterBraintreePlugin extends FlutterBraintreePlatform {
  static void registerWith(Registrar registrar) {
    FlutterBraintreePlatform.instance = FlutterBraintreePlugin();
  }

  @override
  Future<BraintreeDeviceData?> requestDeviceData(
    String authorization,
  ) async {
    final client_package.Client clientInstance =
        await promiseToFuture<client_package.Client>(
      client_package.create(
        client_package.Options(authorization: authorization),
      ),
    );

    final data_collector_package.DataCollector dataCollector =
        await promiseToFuture<data_collector_package.DataCollector>(
      data_collector_package.create(
        data_collector_package.Options(
          client: clientInstance,
        ),
      ),
    );

    final String deviceData = await promiseToFuture<String>(
      dataCollector.getDeviceData(),
    );

    return BraintreeDeviceData(deviceData: deviceData);
  }

  @override
  Future<BraintreePaymentMethodNonce?> requestPaypalNonce(
    String authorization,
    BraintreePayPalRequest request,
  ) async {
    final client_package.Client clientInstance =
        await promiseToFuture<client_package.Client>(
      client_package.create(
        client_package.Options(authorization: authorization),
      ),
    );

    final paypal_package.Paypal paypal =
        await promiseToFuture<paypal_package.Paypal>(
      paypal_package.create(paypal_package.Options(client: clientInstance)),
    );

    final tokenizePayload =
        await promiseToFuture<paypal_package.TokenizePayload>(
      paypal.tokenize(
        paypal_package.TokenizeOptions(
          flow: 'vault',
          displayName: request.displayName,
          billingAgreementDescription: request.billingAgreementDescription,
        ),
      ),
    );

    return BraintreePaymentMethodNonce(
        nonce: tokenizePayload.nonce, typeLabel: tokenizePayload.type);
  }

  @override
  Future<BraintreePaymentMethodNonce?> tokenizeCreditCard(
    String authorization,
    BraintreeCreditCardRequest request,
  ) async {
    final client_package.Client clientInstance =
        await promiseToFuture<client_package.Client>(
      client_package.create(
        client_package.Options(authorization: authorization),
      ),
    );

    final requestPayload = await promiseToFuture<client_package.RequestPayload>(
      clientInstance.request(
        client_package.RequestOptions(
          data: client_package.RequestData(
            creditCard: client_package.CreditCard(
                cvv: request.cvv!,
                number: request.cardNumber!,
                expirationDate:
                    '${request.expirationMonth}/${request.expirationYear}'),
          ),
          method: 'post',
          endpoint: 'payment_methods/credit_cards',
        ),
      ),
    );

    if (requestPayload.creditCards.isNotEmpty) {
      return BraintreePaymentMethodNonce(
          nonce: requestPayload.creditCards.first.nonce,
          typeLabel: requestPayload.creditCards.first.type);
    }
  }

  @override
  Future<BraintreePaymentMethodNonce?> requestThreeDSNonce(
    String authorization,
    BraintreeThreeDSecureRequest request,
  ) async {
    final client_package.Client clientInstance =
        await promiseToFuture<client_package.Client>(
      client_package.create(
        client_package.Options(authorization: authorization),
      ),
    );

    final threeDSecure =
        await promiseToFuture<three_d_secure_package.ThreeDSecure>(
      three_d_secure_package.create(
        three_d_secure_package.Options(
          client: clientInstance,
          version: '2',
        ),
      ),
    );

    threeDSecure.on(
      'lookup-complete',
      allowInterop((
          [three_d_secure_package.DataPayload? dataPayload, Function? next]) {
        next!();
      }),
    );

    final challengeResponse =
        await promiseToFuture<three_d_secure_package.ChallengeResponse>(
      threeDSecure.verifyCard(
        three_d_secure_package.VerifyCardPayload(
          email: request.email!,
          amount: request.amount!,
          nonce: request.nonce!,
          billingAddress: three_d_secure_package.BillingAddress(
            phoneNumber: request.address!.phoneNumber!,
          ),
        ),
      ),
    );

    final challengeCancelCode = challengeResponse
        .rawCardinalSDKVerificationData?.Payment?.ExtendedData?.ChallengeCancel;
    if (challengeResponse.nonce.isNotEmpty && challengeCancelCode == null) {
      return BraintreePaymentMethodNonce(
          nonce: challengeResponse.nonce, typeLabel: challengeResponse.type);
    } else {
      return null;
    }
  }
}
