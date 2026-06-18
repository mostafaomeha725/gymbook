import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
