import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/auth/domain/repositories/auth_repository.dart';

class SendResetPasswordEmailUseCase {
  final AuthRepository repository;

  SendResetPasswordEmailUseCase(this.repository);

  Future<Either<Failure, void>> call({required String email}) {
    return repository.sendResetPasswordEmail(email: email);
  }
}
