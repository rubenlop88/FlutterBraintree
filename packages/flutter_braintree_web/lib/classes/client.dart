@JS()
library client;

import 'package:js/js.dart';

@JS()
@anonymous
class Client {
  external Configuration Function() get getConfiguration;
  external RequestPayload Function(RequestOptions requestOptions) get request;

  external factory Client({Function getConfiguration, Function request});
}

@JS()
@anonymous
class RequestPayload {
  external List<TokenizedCreditCard> creditCards;

  external factory RequestPayload({List<TokenizedCreditCard> creditCards});
}

@JS()
@anonymous
class RequestOptions {
  external RequestData data;
  external String endpoint;
  external String method;

  external factory RequestOptions({
    RequestData data,
    String endpoint,
    String method,
  });
}

@JS()
@anonymous
class RequestData {
  external CreditCard creditCard;

  external factory RequestData({CreditCard creditCard});
}

@JS()
@anonymous
class TokenizedCreditCard {
  external String nonce;
  external String type;

  external factory TokenizedCreditCard({
    String nonce,
    String type,
  });
}

@JS()
@anonymous
class CreditCard {
  external String number;
  external String cvv;
  external String expirationDate;
  external CreditCardOptions? options;
  external CreditBillingAddress? billingAddress;

  external factory CreditCard({
    String number,
    String cvv,
    String expirationDate,
    CreditCardOptions? options,
    CreditBillingAddress? billingAddress,
  });
}

@JS()
@anonymous
class CreditCardOptions {
  external bool validate;

  external factory CreditCardOptions({bool validate});
}

@JS()
@anonymous
class CreditBillingAddress {
  external String? postalCode;

  external factory CreditBillingAddress({String? postalCode});
}

@JS()
@anonymous
external Configuration getConfiguration();

@JS()
@anonymous
class Configuration {
  external GatewayConfiguration get gatewayConfiguration;
  external AnalyticsMetadata get analyticsMetadata;
  external String get authorization;

  external factory Configuration({
    GatewayConfiguration gatewayConfiguration,
    AnalyticsMetadata analyticsMetadata,
    String authorization,
  });
}

@JS()
@anonymous
class GatewayConfiguration {
  external String get merchantId;
  external String get assetsUrl;
  external String get environment;
  external String get configUrl;
  external String get clientApiUrl;
  external List<String> get challenges;
  external CreditCards get creditCards;
  external ApplePayWeb get applePayWeb;
  external BraintreeApi get braintreeApi;
  external Paypal get paypal;
  external PayWithVenmo get payWithVenmo;
  external Analytics get analytics;
  external VisaCheckout get visaCheckout;

  external factory GatewayConfiguration({
    String merchantId,
    String assetsUrl,
    String environment,
    String configUrl,
    String clientApiUrl,
    CreditCards creditCards,
  });
}

@JS()
@anonymous
class CreditCards {
  external bool get collectDeviceData;
  external List<String> get supportedCardTypes;
  external List<SupportedGateway> get supportedGateways;

  external factory CreditCards({
    bool collectDeviceData,
    List<String> supportedCardTypes,
    List<SupportedGateway> supportedGateways,
  });
}

@JS()
@anonymous
class SupportedGateway {
  external String get name;

  external factory SupportedGateway({
    String name,
  });
}

@JS()
@anonymous
class ApplePayWeb {
  external String get merchantIdentifier;
  external List<String> get supportedNetworks;

  external factory ApplePayWeb({
    String merchantIdentifier,
    List<String> supportedNetworks,
  });
}

@JS()
@anonymous
class BraintreeApi {
  external String get accessToken;
  external String get url;

  external factory BraintreeApi({
    String accessToken,
    String url,
  });
}

@JS()
@anonymous
class Paypal {
  external String get assetsUrl;
  external String get displayName;

  external factory Paypal({
    String assetsUrl,
    String displayName,
  });
}

@JS()
@anonymous
class PayWithVenmo {
  external String get accessToken;
  external String get environment;
  external String get merchantId;

  external factory PayWithVenmo({
    String accessToken,
    String environment,
    String merchantId,
  });
}

@JS()
@anonymous
class Analytics {
  external String get url;

  external factory Analytics({
    String url,
  });
}

@JS()
@anonymous
class VisaCheckout {
  external String get apikey;
  external String get externalClientId;
  external List<String> get supportedCardTypes;

  external factory VisaCheckout({
    String apikey,
    String externalClientId,
    List<String> supportedCardTypes,
  });
}

@JS()
@anonymous
class AnalyticsMetadata {
  external String get sdkVersion;
  external String get merchantAppId;
  external String get sessionId;
  external String get platform;
  external String get source;
  external String get integration;
  external String get integrationType;
  external List<String> get supportedCardTypes;

  external factory AnalyticsMetadata({
    String sdkVersion,
    String merchantAppId,
    String sessionId,
    String platform,
    String source,
    String integration,
    String integrationType,
    List<String> supportedCardTypes,
  });
}

@JS('braintree.client.create')
external Client create(Options options);

@JS()
@anonymous
class Options {
  external String get authorization;

  external factory Options({String authorization});
}
