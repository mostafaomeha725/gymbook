import 'package:gymbook/features/payments/domain/entities/payment_transaction_status_entity.dart';

class PaymentTransactionStatusModel extends PaymentTransactionStatusEntity {
  const PaymentTransactionStatusModel({
    required super.transactionId,
    required super.status,
    super.paidAt,
    required super.amount,
    required super.currency,
    required super.packageId,
  });

  factory PaymentTransactionStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentTransactionStatusModel(
      transactionId: json['transactionId'] as int,
      status: json['status'] as int,
      paidAt: json['paidAt'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      packageId: json['packageId'] as int,
    );
  }
}
