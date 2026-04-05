import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/auth/domain/repositories/auth_repository.dart';

class ResendConfirmationEmailUseCase {
  final AuthRepository repository;

  ResendConfirmationEmailUseCase(this.repository);

  Future<Either<Failure, void>> call({required String email}) {
    return repository.resendConfirmationEmail(email: email);
  }
}
