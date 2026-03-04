import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/auth/domain/entities/login_result_entity.dart';
import 'package:gymbook/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResultEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, LoginResultEntity>> loginWithGoogle();

  Future<Either<Failure, UserEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required bool isOwner,
  });
}
