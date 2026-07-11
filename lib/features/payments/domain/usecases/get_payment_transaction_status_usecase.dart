import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/payments/domain/entities/payment_transaction_status_entity.dart';
import 'package:gymbook/features/payments/domain/repositories/payments_repository.dart';

class GetPaymentTransactionStatusUseCase {
  final PaymentsRepository repository;

  GetPaymentTransactionStatusUseCase(this.repository);

  Future<Either<Failure, PaymentTransactionStatusEntity>> call(
    int transactionId,
  ) {
    return repository.getPaymentTransactionStatus(transactionId);
  }
}
