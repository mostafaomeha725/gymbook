import 'package:dartz/dartz.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/enums/app_enums.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:gymbook/features/auth/data/model/login_response.dart';
import 'package:gymbook/features/auth/data/model/register_response.dart';
import 'package:gymbook/features/auth/domain/entities/login_result_entity.dart';
import 'package:gymbook/features/auth/domain/entities/user_entity.dart';
import 'package:gymbook/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final PreferencesStorage storage;
  final NetworkService networkService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storage,
    required this.networkService,
  });

  @override
  Future<Either<Failure, void>> sendResetPasswordEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.sendResetPasswordEmail(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> resendConfirmationEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.resendConfirmationEmail(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> validateResetPasswordCode({
    required String email,
    required String code,
  }) async {
    try {
      final isValid = await remoteDataSource.validateResetPasswordCode(
        email: email,
        code: code,
      );
      return Right(isValid);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, LoginResultEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await _saveSession(response);
      return Right(_mapToLoginResult(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, LoginResultEntity>> loginWithGoogle() async {
    try {
      final response = await remoteDataSource.loginWithGoogle();
      await _saveSession(response);
      return Right(_mapToLoginResult(response));
    } on UserCancelledException {
      return const Left(UserCancelledFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required bool isOwner,
  }) async {
    try {
      final response = await remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        isOwner: isOwner,
      );
      return Right(_mapToUserEntity(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  // ─── Private helpers ───────────────────────────────────────────────────────

  Future<void> _saveSession(LoginResponse response) async {
    await storage.saveUserToken(response.accessToken);
    await storage.saveUserRole(response.user.role == AppUserRole.admin);
    await storage.saveUserId(response.user.id);
    await storage.saveUserSecretKey(response.user.secretKey);
    networkService.addToken(response.accessToken);
  }

  LoginResultEntity _mapToLoginResult(LoginResponse response) {
    return LoginResultEntity(
      accessToken: response.accessToken,
      user: UserEntity(
        id: response.user.id,
        email: response.user.email,
        firstName: response.user.firstName,
        lastName: response.user.lastName,
        fullName: response.user.fullName,
        role: response.user.role,
      ),
    );
  }

  UserEntity _mapToUserEntity(RegisterResponse response) {
    return UserEntity(
      id: response.id,
      email: response.email,
      firstName: response.firstName,
      lastName: response.lastName,
      fullName: response.fullName,
      role: parseAppUserRole(response.role),
    );
  }
}
