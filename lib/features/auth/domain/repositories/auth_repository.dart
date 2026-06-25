import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/auth/domain/entities/login_result_entity.dart';
import 'package:gymbook/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendResetPasswordEmail({required String email});

  Future<Either<Failure, void>> resendConfirmationEmail({
    required String email,
  });

  Future<Either<Failure, void>> confirmEmail({
    required String email,
    required String code,
  });

  Future<Either<Failure, bool>> validateResetPasswordCode({
    required String email,
    required String code,
  });

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmNewPassword,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });

  Future<Either<Failure, LoginResultEntity>> login({
    required String email,
    required String password,
    required int userType,
  });

  Future<Either<Failure, LoginResultEntity>> loginWithGoogle(int userType);

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required bool isOwner,
  });

  Future<void> confirmPendingSession();
  
  void clearPendingSession();
}
