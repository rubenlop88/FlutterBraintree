@JS()
library three_d_scure;

import 'package:flutter_braintree_web/classes/client.dart';
import 'package:js/js.dart';

@JS('braintree.threeDSecure.create')
external ThreeDSecure create(Options options);

@JS()
@anonymous
class ThreeDSecure {
  external void Function(String event,
      Function([DataPayload dataPayload, Function next]) handler) get on;
  external ChallengeResponse Function(VerifyCardPayload verifyCardPayload)
      get verifyCard;
  external Future<void> Function() get teardown;

  external factory ThreeDSecure(
      {Function verifyCard, Function on, Function teardown});
}

@JS()
@anonymous
class DataPayload {
  external factory DataPayload();
}

@JS()
@anonymous
class VerifyCardPayload {
  external String get amount;
  external String get nonce;
  external String get bin;
  external String get email;
  external BillingAddress get billingAddress;
  external AdditionalInformation get additionalInformation;

  external factory VerifyCardPayload({
    String amount,
    String nonce,
    String bin,
    String email,
    BillingAddress billingAddress,
    AdditionalInformation additionalInformation,
  });
}

@JS()
@anonymous
class AdditionalInformation {
  external String get workPhoneNumber;
  external String get shippingGivenName;
  external String get shippingSurname;
  external ShippingAddress get shippingAddress;
  external String get shippingPhone;

  external factory AdditionalInformation({
    String workPhoneNumber,
    String shippingGivenName,
    String shippingSurname,
    ShippingAddress shippingAddress,
    String shippingPhone,
  });
}

@JS()
@anonymous
class ShippingAddress {
  external String get streetAddress;
  external String get extendedAddress;
  external String get locality;
  external String get region;
  external String get postalCode;
  external String get countryCodeAlpha2;

  external factory ShippingAddress({
    String streetAddress,
    String extendedAddress,
    String locality,
    String region,
    String postalCode,
    String countryCodeAlpha2,
  });
}

@JS()
@anonymous
class BillingAddress {
  external String get givenName;
  external String get surname;
  external String get phoneNumber;
  external String get streetAddress;
  external String get extendedAddress;
  external String get locality;
  external String get region;
  external String get postalCode;
  external String get countryCodeAlpha2;

  external factory BillingAddress({
    String givenName,
    String surname,
    String phoneNumber,
    String streetAddress,
    String extendedAddress,
    String locality,
    String region,
    String postalCode,
    String countryCodeAlpha2,
  });
}

@JS()
@anonymous
class ChallengeResponse {
  external String nonce;
  external bool liabilityShifted;
  external bool liabilityShiftPossible;
  external String type;
  external RawCardinalSDKVerificationData? get rawCardinalSDKVerificationData;

  external factory ChallengeResponse({
    String nonce,
    bool liabilityShifted,
    bool liabilityShiftPossible,
    String type,
    RawCardinalSDKVerificationData? rawCardinalSDKVerificationData,
  });
}

@JS()
@anonymous
class RawCardinalSDKVerificationData {
  external PaymentData? get Payment;
  external factory RawCardinalSDKVerificationData({PaymentData? Payment});
}

@JS()
@anonymous
class PaymentData {
  external ExtendedDataDart? get ExtendedData;

  external factory PaymentData({ExtendedDataDart? ExtendedDataDart});
}

@JS()
@anonymous
class ExtendedDataDart {
  external String? get ChallengeCancel;

  external factory ExtendedDataDart({String? ChallengeCancel});
}

@JS()
@anonymous
class Options {
  external Client get client;
  external String get version;

  external factory Options({Client client, String version});
}
