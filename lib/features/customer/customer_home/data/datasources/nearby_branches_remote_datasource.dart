import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/customer/customer_home/data/models/nearby_branches_response_model.dart';

abstract class NearbyBranchesRemoteDataSource {
  Future<NearbyBranchesResponseModel> getNearbyBranches({
    double? latitude,
    double? longitude,
    required int radiusInMeters,
    required int pageNumber,
    required int pageSize,
    String? search,
  });
}

class NearbyBranchesRemoteDataSourceImpl
    implements NearbyBranchesRemoteDataSource {
  final NetworkService networkService;

  NearbyBranchesRemoteDataSourceImpl(this.networkService);

  @override
  Future<NearbyBranchesResponseModel> getNearbyBranches({
    double? latitude,
    double? longitude,
    required int radiusInMeters,
    required int pageNumber,
    required int pageSize,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };

    if (latitude != null && longitude != null) {
      final safeRadius = radiusInMeters.clamp(1, 15000).toInt();
      params['Latitude'] = latitude;
      params['Longitude'] = longitude;
      params['RadiusInMeters'] = safeRadius;
    }

    if (search != null && search.trim().isNotEmpty) {
      params['Search'] = search.trim();
    }

    final response = await networkService.getData(
      endPoint: EndPoints.getNearbyBranches,
      queryParameters: params,
    );

    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) =>
          NearbyBranchesResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
