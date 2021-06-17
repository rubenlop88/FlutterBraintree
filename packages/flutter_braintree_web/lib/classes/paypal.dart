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
class Paypal {
  external TokenizePayload Function({
    String flow,
    String? displayName,
    String? billingAgreementDescription,
  }) get tokenize;

  external factory Paypal({
    String flow,
    String displayName,
    String billingAgreementDescription,
  });
}

@JS('braintree.paypal.create')
external dynamic create(Options options);

@JS()
@anonymous
class Options {
  external Client get client;

  external factory Options({Client client});
}
