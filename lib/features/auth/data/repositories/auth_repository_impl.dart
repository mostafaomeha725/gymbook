import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:gymbook/core/cache/hive_boxes.dart';
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

  LoginResponse? _pendingLoginResponse;

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
  Future<Either<Failure, void>> confirmEmail({
    required String email,
    required String code,
  }) async {
    try {
      await remoteDataSource.confirmEmail(email: email, code: code);
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
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = storage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await remoteDataSource.logout(refreshToken: refreshToken);
      }
      await _clearAllLocalData();
      return const Right(null);
    } on ServerException catch (e) {
      await _clearAllLocalData();
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      await _clearAllLocalData();
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<void> _clearAllLocalData() async {
    _pendingLoginResponse = null;
    networkService.removeToken();
    await storage.clear(); // Clear all SharedPreferences

    try {
      // 1. Wipe everything from disk (all boxes, all data)
      await Hive.deleteFromDisk();
      // 2. Reopen the cacheBox so the app can continue working without restarting
      await Hive.openBox<String>(HiveBoxes.cacheBox);
    } catch (e) {
      // Ignore if it fails to delete or reopen
    }
  }

  @override
  Future<Either<Failure, LoginResultEntity>> login({
    required String email,
    required String password,
    required int userType,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
        userType: userType,
      );
      if (response.user.emailConfirmed) {
        await _saveSession(response);
      } else {
        _pendingLoginResponse = response;
      }
      return Right(_mapToLoginResult(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, LoginResultEntity>> loginWithGoogle(int userType) async {
    try {
      final response = await remoteDataSource.loginWithGoogle(userType);
      if (response.user.emailConfirmed) {
        await _saveSession(response);
      } else {
        _pendingLoginResponse = response;
      }
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
    await storage.saveRefreshToken(response.refreshToken.token);
    await storage.saveUserRole(
      response.user.role == AppUserRole.owner ||
          response.user.role == AppUserRole.branchAdmin,
    );
    await storage.saveUserId(response.user.id);
    await storage.saveUserSecretKey(response.user.secretKey);
    await storage.saveUserEmailConfirmed(response.user.emailConfirmed);
    await storage.putString(
      key: PreferencesKeys.email,
      value: response.user.email,
    );

    // Save extended role details
    await storage.saveUserType(response.user.userType);
    if (response.user.worksAtBranch != null) {
      await storage.saveRoleId(response.user.worksAtBranch!.roleId);
      await storage.saveBranchId(response.user.worksAtBranch!.branchId);
      await storage.saveBranchName(response.user.worksAtBranch!.branchName);
    }

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
        userType: response.user.userType,
        roleId: response.user.worksAtBranch?.roleId,
        branchId: response.user.worksAtBranch?.branchId,
        branchName: response.user.worksAtBranch?.branchName,
        role: response.user.role,
        emailConfirmed: response.user.emailConfirmed,
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
      userType: parseAppUserRole(response.role) == AppUserRole.owner ? 2 : 4,
      role: parseAppUserRole(response.role),
      emailConfirmed: response.emailConfirmed,
    );
  }

  @override
  Future<void> confirmPendingSession() async {
    if (_pendingLoginResponse != null) {
      await _saveSession(_pendingLoginResponse!);
      _pendingLoginResponse = null;
    }
  }

  @override
  void clearPendingSession() {
    _pendingLoginResponse = null;
    storage.deleteUserToken();
    storage.deleteRefreshToken();
    networkService.removeToken();
  }
}
