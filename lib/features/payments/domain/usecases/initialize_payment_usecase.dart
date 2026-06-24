import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/payments/domain/entities/payment_intent_entity.dart';
import 'package:gymbook/features/payments/domain/repositories/payments_repository.dart';

class InitializePaymentUseCase {
  final PaymentsRepository repository;

  InitializePaymentUseCase(this.repository);

  Future<Either<Failure, PaymentIntentEntity>> call({
    required int branchId,
    required int packageId,
  }) {
    return repository.initializePayment(
      branchId: branchId,
      packageId: packageId,
    );
  }
}
