import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/auth/domain/entities/login_result_entity.dart';
import 'package:gymbook/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResultEntity>> call({
    required String email,
    required String password,
    required int userType,
  }) {
    return repository.login(email: email, password: password, userType: userType);
  }
}
