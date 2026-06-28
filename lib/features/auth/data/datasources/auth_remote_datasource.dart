import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/core/services/google_sign_in_service.dart';
import 'package:gymbook/features/auth/data/model/login_response.dart';
import 'package:gymbook/features/auth/data/model/register_response.dart';
import 'package:gymbook/core/error/failure.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendResetPasswordEmail({required String email});

  Future<void> resendConfirmationEmail({required String email});

  Future<void> confirmEmail({required String email, required String code});

  Future<bool> validateResetPasswordCode({
    required String email,
    required String code,
  });

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmNewPassword,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });

  Future<LoginResponse> login({
    required String email,
    required String password,
    required int userType,
  });

  Future<LoginResponse> loginWithGoogle(int userType);

  Future<void> logout({required String refreshToken});

  Future<RegisterResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required bool isOwner,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkService networkService;

  AuthRemoteDataSourceImpl(this.networkService);

  @override
  Future<void> sendResetPasswordEmail({required String email}) async {
    final result = await networkService.postData(
      endPoint: EndPoints.forgotPassword,
      data: {'email': email},
    );

    result.fold(
      (failure) => throw ServerException(failure.message),
      (_) => null,
    );
  }

  @override
  Future<void> resendConfirmationEmail({required String email}) async {
    final result = await networkService.postData(
      endPoint: EndPoints.resendConfirmationEmail,
      data: {'email': email},
    );

    result.fold(
      (failure) => throw ServerException(failure.message),
      (_) => null,
    );
  }

  @override
  Future<void> confirmEmail({required String email, required String code}) async {
    final result = await networkService.postData(
      endPoint: EndPoints.confirmEmail,
      data: {'email': email, 'code': code},
    );

    result.fold(
      (failure) => throw ServerException(failure.message),
      (_) => null,
    );
  }

  @override
  Future<bool> validateResetPasswordCode({
    required String email,
    required String code,
  }) async {
    final result = await networkService.postData(
      endPoint: EndPoints.validateResetPasswordCode,
      data: {'email': email, 'code': code},
    );

    return result.fold((failure) => throw ServerException(failure.message), (
      data,
    ) {
      if (data is Map<String, dynamic>) {
        return data['isValid'] == true;
      }
      throw const ServerException('Unexpected response format');
    });
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final result = await networkService.postData(
      endPoint: EndPoints.resetPassword,
      data: {
        'email': email,
        'code': code,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      },
    );

    result.fold(
      (failure) => throw ServerException(failure.message),
      (_) => null,
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final result = await networkService.postData(
      endPoint: EndPoints.changePassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      },
    );

    result.fold(
      (failure) => throw ServerException(failure.message),
      (_) => null,
    );
  }

  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
    required int userType,
  }) async {
    final result = await networkService.postData(
      endPoint: EndPoints.login,
      data: {'email': email, 'password': password, 'userType': userType},
    );

    return result.fold(
      (failure) {
        if (failure is EmailNotVerifiedFailure) {
          throw EmailNotVerifiedException(failure.message);
        }
        throw ServerException(failure.message);
      },
      (data) => LoginResponse.fromJson(data),
    );
  }

  @override
  Future<LoginResponse> loginWithGoogle(int userType) async {
    final idToken = await GoogleSignInService.getIdToken();

    final result = await networkService.postData(
      endPoint: EndPoints.googleLogin,
      data: {'idToken': idToken, 'userType': userType},
    );
    return result.fold(
      (failure) {
        if (failure is EmailNotVerifiedFailure) {
          throw EmailNotVerifiedException(failure.message);
        }
        throw ServerException(failure.message);
      },
      (data) => LoginResponse.fromJson(data),
    );
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    final result = await networkService.postData(
      endPoint: EndPoints.logout,
      data: {'refreshToken': refreshToken},
    );

    result.fold(
      (failure) => throw ServerException(failure.message),
      (_) => null,
    );
  }

  @override
  Future<RegisterResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required bool isOwner,
  }) async {
    final result = await networkService.postData(
      endPoint: isOwner ? EndPoints.registerOwner : EndPoints.registerUser,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'phoneNumber': phoneNumber,
      },
    );

    return result.fold(
      (failure) => throw ServerException(failure.message),
      (data) => RegisterResponse.fromJson(data),
    );
  }
}
