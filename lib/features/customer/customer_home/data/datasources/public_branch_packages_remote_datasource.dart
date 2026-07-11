import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/customer/customer_home/data/models/public_branch_package_model.dart';

abstract class PublicBranchPackagesRemoteDataSource {
  Future<PublicBranchPackagesResponse> getBranchPackages({
    required int branchId,
    required int pageNumber,
    required int pageSize,
  });
}

class PublicBranchPackagesRemoteDataSourceImpl
    implements PublicBranchPackagesRemoteDataSource {
  final NetworkService networkService;

  PublicBranchPackagesRemoteDataSourceImpl(this.networkService);

  @override
  Future<PublicBranchPackagesResponse> getBranchPackages({
    required int branchId,
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getPublicBranchPackages(branchId),
      queryParameters: {'PageNumber': pageNumber, 'PageSize': pageSize},
    );

    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => PublicBranchPackagesResponse.fromJson(data as Map<String, dynamic>),
    );
  }
}
