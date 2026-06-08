import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/auth/domain/repositories/auth_repository.dart';

class ConfirmEmailUseCase {
  final AuthRepository repository;

  ConfirmEmailUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String code,
  }) async {
    return await repository.confirmEmail(email: email, code: code);
  }
}
