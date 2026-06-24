import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/payments/domain/repositories/payments_repository.dart';

class PresentPaymentSheetUseCase {
  final PaymentsRepository repository;

  PresentPaymentSheetUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.presentPaymentSheet();
  }
}
