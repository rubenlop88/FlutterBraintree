@JS()
library paypal;

import 'package:flutter_braintree_web/classes/client.dart';
import 'package:js/js.dart';

@JS()
@anonymous
class TokenizePayload {
  external String nonce;
  external String type;

  external factory TokenizePayload({
    String nonce,
    String type,
  });
}

@JS()
@anonymous
class TokenizeOptions {
  external String flow;
  external String? displayName;
  external String? billingAgreementDescription;

  external factory TokenizeOptions({
    String flow,
    String? displayName,
    String? billingAgreementDescription,
  });
}

@JS()
@anonymous
class Paypal {
  external TokenizePayload Function(
    TokenizeOptions tokenizeOptions,
  ) get tokenize;

  external factory Paypal({Function tokenize});
}

@JS('braintree.paypal.create')
external Paypal create(Options options);

@JS()
@anonymous
class Options {
  external Client get client;

  external factory Options({Client client});
}
