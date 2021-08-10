import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

void main() => runApp(
      MaterialApp(
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final String tokenizationKey =
      'eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJleUowZVhBaU9pSktWMVFpTENKaGJHY2lPaUpGVXpJMU5pSXNJbXRwWkNJNklqSXdNVGd3TkRJMk1UWXRjMkZ1WkdKdmVDSXNJbWx6Y3lJNkltaDBkSEJ6T2k4dllYQnBMbk5oYm1SaWIzZ3VZbkpoYVc1MGNtVmxaMkYwWlhkaGVTNWpiMjBpZlEuZXlKbGVIQWlPakUyTWpnMk16VXhNVGNzSW1wMGFTSTZJakUwWlRReVpUWXpMV0ZrWmpndE5HUTNZeTFoTW1ZNExUUTNNell5WldFNU0yWXpNQ0lzSW5OMVlpSTZJbm8xZVdwMk9XaHVPSG8xYW5SMGJUSWlMQ0pwYzNNaU9pSm9kSFJ3Y3pvdkwyRndhUzV6WVc1a1ltOTRMbUp5WVdsdWRISmxaV2RoZEdWM1lYa3VZMjl0SWl3aWJXVnlZMmhoYm5RaU9uc2ljSFZpYkdsalgybGtJam9pZWpWNWFuWTVhRzQ0ZWpWcWRIUnRNaUlzSW5abGNtbG1lVjlqWVhKa1gySjVYMlJsWm1GMWJIUWlPblJ5ZFdWOUxDSnlhV2RvZEhNaU9sc2liV0Z1WVdkbFgzWmhkV3gwSWwwc0luTmpiM0JsSWpwYklrSnlZV2x1ZEhKbFpUcFdZWFZzZENKZExDSnZjSFJwYjI1eklqcDdJbU4xYzNSdmJXVnlYMmxrSWpvaVluUXRZMnhzTFhWelpYSXRPVFl5T1RJeklpd2liV1Z5WTJoaGJuUmZZV05qYjNWdWRGOXBaQ0k2SW5SM2IyNWhjbmtpZlgwLk5VUVBVSE83WXFjamhWZnI1bnNaMUttX0VNc0JmV0UzQWJZTUZtZVlDNVRSb1FxWWxKVkg3Z1hoOTZoTFhITTdoQ25LbkczZDU3a3F4eWtkLVNvOEtBP2N1c3RvbWVyX2lkPSIsImNvbmZpZ1VybCI6Imh0dHBzOi8vYXBpLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb206NDQzL21lcmNoYW50cy96NXlqdjlobjh6NWp0dG0yL2NsaWVudF9hcGkvdjEvY29uZmlndXJhdGlvbiIsIm1lcmNoYW50QWNjb3VudElkIjoidHdvbmFyeSIsImdyYXBoUUwiOnsidXJsIjoiaHR0cHM6Ly9wYXltZW50cy5zYW5kYm94LmJyYWludHJlZS1hcGkuY29tL2dyYXBocWwiLCJkYXRlIjoiMjAxOC0wNS0wOCIsImZlYXR1cmVzIjpbInRva2VuaXplX2NyZWRpdF9jYXJkcyJdfSwiaGFzQ3VzdG9tZXIiOnRydWUsImNsaWVudEFwaVVybCI6Imh0dHBzOi8vYXBpLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb206NDQzL21lcmNoYW50cy96NXlqdjlobjh6NWp0dG0yL2NsaWVudF9hcGkiLCJlbnZpcm9ubWVudCI6InNhbmRib3giLCJtZXJjaGFudElkIjoiejV5anY5aG44ejVqdHRtMiIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwidmVubW8iOiJvZmYiLCJjaGFsbGVuZ2VzIjpbImN2diJdLCJ0aHJlZURTZWN1cmVFbmFibGVkIjp0cnVlLCJhbmFseXRpY3MiOnsidXJsIjoiaHR0cHM6Ly9vcmlnaW4tYW5hbHl0aWNzLXNhbmQuc2FuZGJveC5icmFpbnRyZWUtYXBpLmNvbS96NXlqdjlobjh6NWp0dG0yIn0sImFwcGxlUGF5Ijp7ImNvdW50cnlDb2RlIjoiVVMiLCJjdXJyZW5jeUNvZGUiOiJVU0QiLCJtZXJjaGFudElkZW50aWZpZXIiOiJtZXJjaGFudC5jb20uYWN1YmEubW9iaWxlLnNhbmRib3giLCJzdGF0dXMiOiJtb2NrIiwic3VwcG9ydGVkTmV0d29ya3MiOlsidmlzYSIsIm1hc3RlcmNhcmQiLCJhbWV4IiwiZGlzY292ZXIiXX0sInBheXBhbEVuYWJsZWQiOnRydWUsInBheXBhbCI6eyJiaWxsaW5nQWdyZWVtZW50c0VuYWJsZWQiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjpmYWxzZSwidW52ZXR0ZWRNZXJjaGFudCI6ZmFsc2UsImFsbG93SHR0cCI6dHJ1ZSwiZGlzcGxheU5hbWUiOiJ0d29uYXJ5IiwiY2xpZW50SWQiOiJBVDllWWItV3JsTkFPVmJtZzd1cElhazJpcTNOdGFVZ3d1Slp2Qk8yMkp0RmJibWhzc0FPazBBN09fREcxMlphMVUtZ3JmS1BBSm93bmNlNyIsInByaXZhY3lVcmwiOiJodHRwOi8vZXhhbXBsZS5jb20vcHAiLCJ1c2VyQWdyZWVtZW50VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3RvcyIsImJhc2VVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImFzc2V0c1VybCI6Imh0dHBzOi8vY2hlY2tvdXQucGF5cGFsLmNvbSIsImRpcmVjdEJhc2VVcmwiOm51bGwsImVudmlyb25tZW50Ijoib2ZmbGluZSIsImJyYWludHJlZUNsaWVudElkIjoibWFzdGVyY2xpZW50MyIsIm1lcmNoYW50QWNjb3VudElkIjoidHdvbmFyeSIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9fQ==';

  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  void showText(String text) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(text),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Braintree example app'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  var request = BraintreeDropInRequest(
                      tokenizationKey: tokenizationKey,
                      collectDeviceData: true,
                      googlePaymentRequest: BraintreeGooglePaymentRequest(
                        totalPrice: '4.20',
                        currencyCode: 'USD',
                        billingAddressRequired: false,
                      ),
                      paypalRequest: BraintreePayPalRequest(
                        amount: '4.20',
                        displayName: 'Example company',
                      ),
                      cardEnabled: true,
                      amount: '12.13',
                      requestThreeDSecureVerification: true);
                  BraintreeDropInResult result =
                      await BraintreeDropIn.start(request);
                  if (result != null) {
                    showNonce(result.paymentMethodNonce);
                  }
                },
                child: Text('LAUNCH NATIVE DROP-IN'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final request = BraintreeCreditCardRequest(
                      cardNumber: '4111111111111111',
                      expirationMonth: '03',
                      expirationYear: '2021',
                      cvv: '123',
                      shouldValidate: true);
                  BraintreePaymentMethodNonce result =
                      await Braintree.tokenizeCreditCard(
                    tokenizationKey,
                    request,
                  );
                  if (result != null) {
                    showNonce(result);
                  }
                },
                child: Text('TOKENIZE CREDIT CARD'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final request = BraintreeCreditCardRequest(
                      cardNumber: '4111111111111111',
                      expirationMonth: '12',
                      expirationYear: '2021',
                      cvv: '123',
                      shouldValidate: false);

                  BraintreePaymentMethodNonce tokenizeResult =
                      await Braintree.tokenizeCreditCard(
                    tokenizationKey,
                    request,
                  );

                  final address = BraintreeThreeDSecurePostalAddress(
                      givenName: 'Jill',
                      surname: 'Doe',
                      phoneNumber: '5551234567');

                  final threeDSRequest = BraintreeThreeDSecureRequest(
                      nonce: tokenizeResult.nonce,
                      amount: '12.12',
                      email: 'test@email.com');

                  BraintreePaymentMethodNonce result =
                      await Braintree.requestThreeDSNonce(
                          tokenizationKey, threeDSRequest);

                  if (result != null) {
                    showNonce(result);
                  }
                },
                child: Text('TOKENIZE CREDIT CARD + 3DS'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final request = BraintreePayPalRequest(
                    billingAgreementDescription:
                        'I hereby agree that flutter_braintree is great.',
                    displayName: 'Your Company',
                  );
                  BraintreePaymentMethodNonce result =
                      await Braintree.requestPaypalNonce(
                    tokenizationKey,
                    request,
                  );
                  if (result != null) {
                    showNonce(result);
                  }
                },
                child: Text('PAYPAL VAULT FLOW'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final request = BraintreePayPalRequest(amount: '13.37');
                  BraintreePaymentMethodNonce result =
                      await Braintree.requestPaypalNonce(
                    tokenizationKey,
                    request,
                  );
                  if (result != null) {
                    showNonce(result);
                  }
                },
                child: Text('PAYPAL CHECKOUT FLOW'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await Braintree.requestDeviceData(
                    tokenizationKey,
                  );

                  if (result != null) {
                    showText(result.deviceData);
                  }
                },
                child: Text('REQUEST DEVICE DATA'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await Braintree.requestPaypalDeviceData(
                    tokenizationKey,
                  );

                  if (result != null) {
                    showText(result.deviceData);
                  }
                },
                child: Text('REQUEST PAYPAL DEVICE DATA'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await Braintree.canMakePaymentsWithApplePay();

                  showText("Can use Apple Pay = $result");
                },
                child: Text('CAN MAKE PAYMENTS WITH APPLE PAY'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final request = BraintreeApplePayRequest(
                      amount: '12.12',
                      appleMerchantID: '',
                      countryCode: '',
                      displayName: '',
                      currencyCode: 'USD');

                  BraintreePaymentMethodNonce result =
                      await Braintree.requestApplePayPayment(
                          tokenizationKey, request);

                  if (result != null) {
                    showNonce(result);
                  }
                },
                child: Text('REQUEST APPLE PAY PAYMENT'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await Braintree.canMakePaymentsWithGooglePay(
                      authorization: tokenizationKey);

                  showText("Can use Google Pay = $result");
                },
                child: Text('CAN MAKE PAYMENTS WITH GOOGLE PAY'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final request = BraintreeGooglePaymentRequest(
                      billingAddressRequired: false,
                      currencyCode: 'USD',
                      googleMerchantID: null,
                      totalPrice: '12.12');

                  BraintreePaymentMethodNonce result =
                      await Braintree.requestGooglePayPayment(
                          tokenizationKey, request);

                  if (result != null) {
                    showNonce(result);
                  }
                },
                child: Text('REQUEST GOOGLE PAY PAYMENT'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await Braintree.canMakePaymentsWithVenmo(
                      authorization: tokenizationKey);

                  showText("Can use Venmo = $result");
                },
                child: Text('CHECK VENMO APP SWITCH'),
              ),
              ElevatedButton(
                onPressed: () async {
                  BraintreePaymentMethodNonce result =
                      await Braintree.requestVenmoNonce(
                    tokenizationKey,
                  );

                  if (result != null) {
                    showNonce(result);
                  }
                },
                child: Text('REQUEST VENMO NONCE'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
