import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/payments/domain/repositories/payments_repository.dart';

class InitPaymentSheetUseCase {
  final PaymentsRepository repository;

  InitPaymentSheetUseCase(this.repository);

  Future<Either<Failure, void>> call(String clientSecret) {
    return repository.initPaymentSheet(clientSecret);
  }
}
