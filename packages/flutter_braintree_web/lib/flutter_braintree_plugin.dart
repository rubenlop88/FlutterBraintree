@JS()
library braintree_web_client;

import 'package:flutter_braintree_platform_interface/flutter_braintree_platform_interface.dart';
import 'package:flutter_braintree_platform_interface/types/request.dart';
import 'package:flutter_braintree_platform_interface/types/result.dart';
import 'package:flutter_braintree_web/classes/client.dart' as client_package;
import 'package:flutter_braintree_web/classes/data_collector.dart'
    as data_collector_package;
import 'package:flutter_braintree_web/classes/paypal.dart' as paypal_package;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

class FlutterBraintreePlugin extends FlutterBraintreePlatform {
  static void registerWith(Registrar registrar) {
    FlutterBraintreePlatform.instance = FlutterBraintreePlugin();
  }

  @override
  Future<BraintreeDeviceData?> requestPayPalDeviceData(
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

    final paypal = await promiseToFuture<paypal_package.Paypal>(
      paypal_package.create(paypal_package.Options(client: clientInstance)),
    );
    final tokenizePayload =
        await promiseToFuture<paypal_package.TokenizePayload>(paypal.tokenize(
      flow: 'vault',
      displayName: request.displayName,
      billingAgreementDescription: request.billingAgreementDescription,
    ));

    return BraintreePaymentMethodNonce(
        nonce: tokenizePayload.nonce, typeLabel: tokenizePayload.type);
  }
}
