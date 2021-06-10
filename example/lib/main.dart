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
  static final String tokenizationKey = 'sandbox_8hxpnkht_kzdtzv2btm4p7s5j';

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
              )
            ],
          ),
        ),
      ),
    );
  }
}
