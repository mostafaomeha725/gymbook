import 'package:equatable/equatable.dart';

class PaymentTransactionStatusEntity extends Equatable {
  final int transactionId;
  final int status;
  final String? paidAt;
  final double amount;
  final String currency;
  final int packageId;

  const PaymentTransactionStatusEntity({
    required this.transactionId,
    required this.status,
    this.paidAt,
    required this.amount,
    required this.currency,
    required this.packageId,
  });

  @override
  List<Object?> get props => [
        transactionId,
        status,
        paidAt,
        amount,
        currency,
        packageId,
      ];
}
