import 'package:gymbook/features/payments/domain/entities/payment_intent_entity.dart';

class PaymentIntentModel extends PaymentIntentEntity {
  const PaymentIntentModel({
    required super.clientSecret,
    required super.paymentTransactionId,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      clientSecret: json['clientSecret'] as String,
      paymentTransactionId: json['paymentTransactionId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientSecret': clientSecret,
      'paymentTransactionId': paymentTransactionId,
    };
  }
}
