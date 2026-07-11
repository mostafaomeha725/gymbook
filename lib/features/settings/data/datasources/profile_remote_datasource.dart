import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/settings/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String? phoneNumber,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final NetworkService networkService;

  ProfileRemoteDataSourceImpl(this.networkService);

  @override
  Future<ProfileModel> getProfile() async {
    final response = await networkService.getData(
      endPoint: EndPoints.getCurrentUser,
    );

    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => ProfileModel.fromJson(data),
    );
  }

  @override
  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String? phoneNumber,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.getCurrentUser,
      data: {
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
      },
    );

    return response.fold(
      (errorString) => throw ServerException(errorString),
      (data) => ProfileModel.fromJson(data),
    );
  }
}
