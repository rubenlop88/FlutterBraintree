import 'dart:convert';

class BraintreeDropInRequest {
  BraintreeDropInRequest({
    this.clientToken,
    this.tokenizationKey,
    this.amount,
    this.collectDeviceData = false,
    this.requestThreeDSecureVerification = false,
    this.googlePaymentRequest,
    this.paypalRequest,
    this.applePayRequest,
    this.venmoEnabled = true,
    this.cardEnabled = true,
    this.maskCardNumber = false,
    this.maskSecurityCode = false,
    this.vaultManagerEnabled = false,
  });

  /// Authorization allowing this client to communicate with Braintree.
  /// Either [clientToken] or [tokenizationKey] must be set.
  String? clientToken;

  /// Authorization allowing this client to communicate with Braintree.
  /// Either [clientToken] or [tokenizationKey] must be set.
  String? tokenizationKey;

  /// Amount for the transaction. This is only used for 3D secure verfications.
  String? amount;

  /// Whether the Drop-in should collect and return device data for fraud prevention.
  bool collectDeviceData;

  /// If 3D Secure has been enabled in the control panel and an amount is specified in
  /// [amount], Drop-In will request a 3D Secure verification for any new cards added by the user.
  bool requestThreeDSecureVerification;

  /// Google Payment request. Google Pay will be disabled if this is set to `null`.
  BraintreeGooglePaymentRequest? googlePaymentRequest;

  /// PayPal request. PayPal will be disabled if this is set to `null`.
  BraintreePayPalRequest? paypalRequest;

  /// Whether Venmo should be enabled.
  bool venmoEnabled;

  /// Whether cards should be enabled.
  bool cardEnabled;

  /// Whether the card number should be masked if the field is not focused.
  bool maskCardNumber;

  /// Whether the security code should be masked during input.
  bool maskSecurityCode;

  /// Whether customers should be allowed to manage their vaulted payment methods.
  bool vaultManagerEnabled;

  /// ApplePay request. ApplePay will be disabled if this is set to `null`.
  /// The ApplePay option will not be visible in the drop-in UI if the setup in
  /// Xcode, App Store Connect or Braintree control panel was done incorrectly.
  BraintreeApplePayRequest? applePayRequest;

  /// Converts this request object into a JSON-encodable format.
  Map<String, dynamic> toJson() => {
        if (clientToken != null) 'clientToken': clientToken,
        if (tokenizationKey != null) 'tokenizationKey': tokenizationKey,
        if (amount != null) 'amount': amount,
        'collectDeviceData': collectDeviceData,
        'requestThreeDSecureVerification': requestThreeDSecureVerification,
        if (googlePaymentRequest != null)
          'googlePaymentRequest': googlePaymentRequest!.toJson(),
        if (paypalRequest != null) 'paypalRequest': paypalRequest!.toJson(),
        if (applePayRequest != null)
          'applePayRequest': applePayRequest!.toJson(),
        'venmoEnabled': venmoEnabled,
        'cardEnabled': cardEnabled,
        'maskCardNumber': maskCardNumber,
        'maskSecurityCode': maskSecurityCode,
        'vaultManagerEnabled': vaultManagerEnabled,
      };
}

class BraintreeCreditCardRequest {
  BraintreeCreditCardRequest({
    required this.cardNumber,
    required this.expirationMonth,
    required this.expirationYear,
    required this.cvv,
    required this.shouldValidate,
  });

  /// Number shown on the credit card.
  String cardNumber;

  /// Two didgit expiration month, e.g. `'05'`.
  String expirationMonth;

  /// Four didgit expiration year, e.g. `'2021'`.
  String expirationYear;

  /// A 3 or 4 digit card verification value assigned to credit cards.
  String cvv;

  /// Should perform card validation
  bool shouldValidate;

  Map<String, dynamic> toJson() => {
        'cardNumber': cardNumber,
        'expirationMonth': expirationMonth,
        'expirationYear': expirationYear,
        'cvv': cvv,
        'shouldValidate': shouldValidate,
      };

  BraintreeCreditCardRequest copyWith({
    String? cardNumber,
    String? expirationMonth,
    String? expirationYear,
    String? cvv,
    bool? shouldValidate,
  }) {
    return BraintreeCreditCardRequest(
        cardNumber: cardNumber ?? this.cardNumber,
        expirationMonth: expirationMonth ?? this.expirationMonth,
        expirationYear: expirationYear ?? this.expirationYear,
        cvv: cvv ?? this.cvv,
        shouldValidate: shouldValidate ?? this.shouldValidate);
  }
}

class BraintreeGooglePaymentRequest {
  BraintreeGooglePaymentRequest({
    required this.totalPrice,
    required this.currencyCode,
    this.billingAddressRequired = true,
    this.googleMerchantID,
  });

  /// Total price of the payment.
  String totalPrice;

  /// Currency code of the transaction.
  String currencyCode;

  /// Whether billing address information should be collected and passed.
  bool billingAddressRequired;

  /// Google Merchant ID. Optional in sandbox, but if set, must be a valid production Google Merchant ID.
  String? googleMerchantID;

  /// Converts this request object into a JSON-encodable format.
  Map<String, dynamic> toJson() => {
        'totalPrice': totalPrice,
        'currencyCode': currencyCode,
        'billingAddressRequired': billingAddressRequired,
        if (googleMerchantID != null) 'googleMerchantID': googleMerchantID,
      };
}

class BraintreePayPalRequest {
  BraintreePayPalRequest({
    this.amount,
    this.currencyCode,
    this.displayName,
    this.billingAgreementDescription,
  });

  /// Amount of the transaction. If [amount] is `null`, PayPal will use the billing agreement (Vault) flow.
  /// If [amount] is set, PayPal will follow the one time payment (Checkout) flow.
  String? amount;

  /// Currency code. If set to null`null`, PayPal will choose it based on the active merchant account in the client token.
  String? currencyCode;

  /// The merchant name displayed in the PayPal flow. If set to `null`, PayPal will use the company name in your Braintree account.
  String? displayName;

  /// Description for the billing agreement for the Vault flow.
  String? billingAgreementDescription;

  /// Converts this request object into a JSON-encodable format.
  Map<String, dynamic> toJson() => {
        if (amount != null) 'amount': amount,
        if (currencyCode != null) 'currencyCode': currencyCode,
        if (displayName != null) 'displayName': displayName,
        if (billingAgreementDescription != null)
          'billingAgreementDescription': billingAgreementDescription,
      };
}

class BraintreeApplePayRequest {
  BraintreeApplePayRequest({
    required this.amount,
    required this.displayName,
    required this.currencyCode,
    required this.countryCode,
    required this.appleMerchantID,
  });

  /// The item's amount.
  final String amount;

  /// Short description of the item.
  final String displayName;

  /// The three-letter ISO 4217 currency code.
  final String currencyCode;

  /// The three-letter ISO 4217 currency code.
  final String countryCode;

  /// Apple merchant identifier.
  final String appleMerchantID;

  /// Converts this request object into a JSON-encodable format.
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currencyCode': currencyCode,
        'displayName': displayName,
        'countryCode': countryCode,
        'appleMerchantID': appleMerchantID,
      };
}

class BraintreeThreeDSecurePostalAddress {
  final String? givenName;
  final String? surname;
  final String? phoneNumber;
  final String? streetAddress;
  final String? extendedAddress;
  final String? locality;
  final String? region;
  final String? postalCode;
  final String? countryCodeAlpha;

  BraintreeThreeDSecurePostalAddress({
    this.givenName,
    this.surname,
    this.phoneNumber,
    this.streetAddress,
    this.extendedAddress,
    this.locality,
    this.region,
    this.postalCode,
    this.countryCodeAlpha,
  });

  BraintreeThreeDSecurePostalAddress copyWith({
    String? givenName,
    String? surname,
    String? phoneNumber,
    String? streetAddress,
    String? extendedAddress,
    String? locality,
    String? region,
    String? postalCode,
    String? countryCodeAlpha,
  }) {
    return BraintreeThreeDSecurePostalAddress(
      givenName: givenName ?? this.givenName,
      surname: surname ?? this.surname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      streetAddress: streetAddress ?? this.streetAddress,
      extendedAddress: extendedAddress ?? this.extendedAddress,
      locality: locality ?? this.locality,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      countryCodeAlpha: countryCodeAlpha ?? this.countryCodeAlpha,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'givenName': givenName,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'streetAddress': streetAddress,
      'extendedAddress': extendedAddress,
      'locality': locality,
      'region': region,
      'postalCode': postalCode,
      'countryCodeAlpha': countryCodeAlpha,
    };
  }

  factory BraintreeThreeDSecurePostalAddress.fromMap(
      Map<String, dynamic>? map) {
    return BraintreeThreeDSecurePostalAddress(
      givenName: map?['givenName'],
      surname: map?['surname'],
      phoneNumber: map?['phoneNumber'],
      streetAddress: map?['streetAddress'],
      extendedAddress: map?['extendedAddress'],
      locality: map?['locality'],
      region: map?['region'],
      postalCode: map?['postalCode'],
      countryCodeAlpha: map?['countryCodeAlpha'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BraintreeThreeDSecurePostalAddress.fromJson(String source) =>
      BraintreeThreeDSecurePostalAddress.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BraintreeThreeDSecurePostalAddress(givenName: $givenName, surname: $surname, phoneNumber: $phoneNumber, streetAddress: $streetAddress, extendedAddress: $extendedAddress, locality: $locality, region: $region, postalCode: $postalCode, countryCodeAlpha: $countryCodeAlpha)';
  }
}

class BraintreeThreeDSecureRequest {
  final String amount;
  final String nonce;
  final String email;
  final BraintreeThreeDSecurePostalAddress? address;

  BraintreeThreeDSecureRequest({
    required this.amount,
    required this.nonce,
    required this.email,
    this.address,
  });

  BraintreeThreeDSecureRequest copyWith({
    String? amount,
    String? nonce,
    String? email,
    BraintreeThreeDSecurePostalAddress? address,
  }) {
    return BraintreeThreeDSecureRequest(
      amount: amount ?? this.amount,
      nonce: nonce ?? this.nonce,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'nonce': nonce,
      'email': email,
      'address': address?.toMap(),
    };
  }

  factory BraintreeThreeDSecureRequest.fromMap(Map<String, dynamic>? map) {
    return BraintreeThreeDSecureRequest(
      amount: map?['amount'],
      nonce: map?['nonce'],
      email: map?['email'],
      address: BraintreeThreeDSecurePostalAddress.fromMap(map?['address']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BraintreeThreeDSecureRequest.fromJson(String source) =>
      BraintreeThreeDSecureRequest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BraintreeThreeDSecureRequest(amount: $amount, nonce: $nonce, email: $email, address: $address)';
  }
}
