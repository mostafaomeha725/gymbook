import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/auth/domain/repositories/auth_repository.dart';

class ValidateResetPasswordCodeUseCase {
  final AuthRepository repository;

  ValidateResetPasswordCodeUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String email,
    required String code,
  }) {
    return repository.validateResetPasswordCode(email: email, code: code);
  }
}
