import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin_home/data/models/branch_packages_response.dart';
import 'package:gymbook/features/admin_home/data/models/create_package_request.dart';
import 'package:gymbook/features/admin_home/data/models/create_package_response.dart';
import 'package:gymbook/features/admin_home/data/models/update_package_request.dart';

abstract class PackageRemoteDataSource {
  Future<CreatePackageResponse> createPackage({
    required int branchId,
    required CreatePackageRequest request,
  });

  Future<CreatePackageResponse> updatePackage({
    required int branchId,
    required int packageId,
    required UpdatePackageRequest request,
  });

  Future<BranchPackagesResponse> getBranchPackages({
    required int branchId,
    required int pageNumber,
    required int pageSize,
  });

  Future<void> updatePackageStatus({
    required int branchId,
    required int packageId,
    required bool isActive,
  });

  Future<void> deletePackage({required int branchId, required int packageId});
}

class PackageRemoteDataSourceImpl implements PackageRemoteDataSource {
  final NetworkService networkService;

  PackageRemoteDataSourceImpl(this.networkService);

  @override
  Future<CreatePackageResponse> createPackage({
    required int branchId,
    required CreatePackageRequest request,
  }) async {
    final response = await networkService.postData(
      endPoint: EndPoints.createPackage(branchId),
      data: request.toJson(),
    );
    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => CreatePackageResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<CreatePackageResponse> updatePackage({
    required int branchId,
    required int packageId,
    required UpdatePackageRequest request,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.updatePackage(branchId, packageId),
      data: request.toJson(),
    );
    return response.fold(
      (failure) => throw ServerException(failure),
      (data) => CreatePackageResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<BranchPackagesResponse> getBranchPackages({
    required int branchId,
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getBranchPackages(branchId),
      queryParameters: {'PageNumber': pageNumber, 'PageSize': pageSize},
    );
    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => BranchPackagesResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<void> updatePackageStatus({
    required int branchId,
    required int packageId,
    required bool isActive,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.updatePackageStatus(branchId, packageId),
      data: {'isActive': isActive},
    );
    response.fold((failure) => throw ServerException(failure), (_) => null);
  }

  @override
  Future<void> deletePackage({
    required int branchId,
    required int packageId,
  }) async {
    final response = await networkService.deleteData(
      endPoint: EndPoints.deletePackage(branchId, packageId),
    );
    response.fold((failure) => throw ServerException(failure), (_) => null);
  }
}
