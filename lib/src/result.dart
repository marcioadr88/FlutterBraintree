class BraintreeDropInResult {
  const BraintreeDropInResult({
    required this.paymentMethodNonce,
    required this.deviceData,
  });

  static BraintreeDropInResult? fromJson(dynamic source) {
    if (source == null) return null;
    final BraintreePaymentMethodNonce? braintreePaymentMethodNonce =
        BraintreePaymentMethodNonce.fromJson(source['paymentMethodNonce']);
    if (braintreePaymentMethodNonce == null) return null;
    return BraintreeDropInResult(
      paymentMethodNonce: braintreePaymentMethodNonce,
      deviceData: source['deviceData'],
    );
  }

  /// The payment method nonce containing all relevant information for the payment.
  final BraintreePaymentMethodNonce paymentMethodNonce;

  /// String of device data. `null`, if `collectDeviceData` was set to false.
  final String? deviceData;
}

class BraintreePaymentMethodNonce {
  const BraintreePaymentMethodNonce({
    required this.nonce,
    required this.typeLabel,
    required this.description,
    required this.isDefault,
  });

  static BraintreePaymentMethodNonce? fromJson(dynamic source) {
    if (source == null) return null;
    return BraintreePaymentMethodNonce(
      nonce: source['nonce'],
      typeLabel: source['typeLabel'],
      description: source['description'],
      isDefault: source['isDefault'],
    );
  }

  /// The nonce generated for this payment method by the Braintree gateway. The nonce will represent
  /// this PaymentMethod for the purposes of creating transactions and other monetary actions.
  final String? nonce;

  /// The type of this PaymentMethod for displaying to a customer, e.g. 'Visa'. Can be used for displaying appropriate logos, etc.
  final String? typeLabel;

  /// The description of this PaymentMethod for displaying to a customer, e.g. 'Visa ending in...'.
  final String? description;

  /// True if this payment method is the default for the current customer, false otherwise.
  final bool? isDefault;
}

class BraintreeDeviceData {
  const BraintreeDeviceData({required this.deviceData});

  static BraintreeDeviceData? fromJson(dynamic source) {
    if (source == null) return null;
    return BraintreeDeviceData(
      deviceData: source['deviceData'],
    );
  }

  final String? deviceData;
}

class BraintreeCanMakePaymentsResult {
  const BraintreeCanMakePaymentsResult({required this.canMakePayments});

  static BraintreeCanMakePaymentsResult? fromJson(dynamic source) {
    if (source == null) return null;
    return BraintreeCanMakePaymentsResult(
      canMakePayments: source['canMakePayments'] ?? false,
    );
  }

  final bool canMakePayments;
}
