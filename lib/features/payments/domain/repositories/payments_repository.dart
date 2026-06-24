import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/payments/domain/entities/payment_intent_entity.dart';
import 'package:gymbook/features/payments/domain/entities/payment_transaction_status_entity.dart';

abstract class PaymentsRepository {
  Future<Either<Failure, PaymentIntentEntity>> initializePayment({
    required int branchId,
    required int packageId,
  });

  Future<Either<Failure, PaymentTransactionStatusEntity>> getPaymentTransactionStatus(
    int transactionId,
  );

  Future<Either<Failure, void>> initPaymentSheet(String clientSecret);

  Future<Either<Failure, void>> presentPaymentSheet();
}
