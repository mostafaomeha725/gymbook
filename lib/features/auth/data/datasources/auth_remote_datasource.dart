import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/core/services/google_sign_in_service.dart';
import 'package:gymbook/features/auth/data/model/login_response.dart';
import 'package:gymbook/features/auth/data/model/register_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login({
    required String email,
    required String password,
  });

  Future<LoginResponse> loginWithGoogle();

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
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final result = await networkService.postData(
      endPoint: EndPoints.login,
      data: {'email': email, 'password': password},
    );

    return result.fold(
      (failure) => throw ServerException(failure.message),
      (data) => LoginResponse.fromJson(data),
    );
  }

  @override
  Future<LoginResponse> loginWithGoogle() async {
    final idToken = await GoogleSignInService.getIdToken();

    if (idToken == null) throw const UserCancelledException();

    final result = await networkService.postData(
      endPoint: EndPoints.googleLogin,
      data: {'idToken': idToken},
    );

    return result.fold(
      (failure) => throw ServerException(failure.message),
      (data) => LoginResponse.fromJson(data),
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
