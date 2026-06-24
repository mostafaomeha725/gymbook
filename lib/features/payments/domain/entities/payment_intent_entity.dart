class PaymentIntentEntity {
  final String clientSecret;
  final int paymentTransactionId;

  const PaymentIntentEntity({
    required this.clientSecret,
    required this.paymentTransactionId,
  });
}
