import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin_home/data/models/branch_details_model.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/data/models/create_branch_model.dart';
import 'package:gymbook/features/admin_home/data/models/package_model.dart';

abstract class AdminBranchRepository {
  Future<Either<String, CreateBranchResponse>> createBranch({
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  });

  Future<Either<String, void>> updateBranchWorkingHours({
    required int branchId,
    required List<Map<String, dynamic>> workingHours,
  });

  Future<Either<String, void>> updateBranchLocationDetails({
    required int branchId,
    required int governorateId,
    required String address,
    required double latitude,
    required double longitude,
  });

  Future<Either<String, BranchListResponse>> getBranches({
    int pageNumber = 1,
    int pageSize = 10,
  });

  Future<Either<String, BranchDetailsResponse>> getBranchDetails(int branchId);

  Future<Either<String, CreatePackageResponse>> createPackage({
    required int branchId,
    required CreatePackageRequest request,
  });

  Future<Either<String, BranchPackagesResponse>> getBranchPackages({
    required int branchId,
    required int pageNumber,
    required int pageSize,
  });

  Future<Either<String, CreatePackageResponse>> updatePackage({
    required int branchId,
    required int packageId,
    required UpdatePackageRequest request,
  });

  Future<Either<String, void>> updatePackageStatus({
    required int branchId,
    required int packageId,
    required bool isActive,
  });

  Future<Either<String, void>> deletePackage({
    required int branchId,
    required int packageId,
  });

  Future<Either<String, void>> updateBranchDetails({
    required int branchId,
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  });

  Future<Either<String, void>> updateBranchStatus({
    required int branchId,
    required int branchStatus,
  });

  Future<Either<String, String>> uploadBranchImage({
    required int branchId,
    required File imageFile,
  });

  Future<Either<String, String>> updateBranchImage({
    required int branchId,
    required int imageId,
    required File imageFile,
  });
}

class AdminBranchRepositoryImpl implements AdminBranchRepository {
  AdminBranchRepositoryImpl(this.networkService);

  final NetworkService networkService;

  @override
  Future<Either<String, CreateBranchResponse>> createBranch({
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) async {
    final response = await networkService.postData(
      endPoint: EndPoints.createBranch,
      data: {
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'branchType': branchType,
      },
    );

    return response.fold(
      (failure) => Left(failure.message),
      (data) =>
          Right(CreateBranchResponse.fromJson(data as Map<String, dynamic>)),
    );
  }

  @override
  Future<Either<String, void>> updateBranchWorkingHours({
    required int branchId,
    required List<Map<String, dynamic>> workingHours,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.updateBranchWorkingHours(branchId),
      data: {'workingHours': workingHours},
    );

    return response.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<String, void>> updateBranchLocationDetails({
    required int branchId,
    required int governorateId,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.updateBranchLocationDetails(branchId),
      data: {
        'governorateId': governorateId,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
      },
    );

    return response.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<String, BranchListResponse>> getBranches({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getBranches,
      queryParameters: {'PageNumber': pageNumber, 'PageSize': pageSize},
    );

    return response.fold(
      (failure) => Left(failure.message),
      (data) =>
          Right(BranchListResponse.fromJson(data as Map<String, dynamic>)),
    );
  }

  @override
  Future<Either<String, BranchDetailsResponse>> getBranchDetails(
    int branchId,
  ) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getBranchDetails(branchId),
    );
    return response.fold(
      (failure) => Left(failure.message),
      (data) =>
          Right(BranchDetailsResponse.fromJson(data as Map<String, dynamic>)),
    );
  }

  @override
  Future<Either<String, CreatePackageResponse>> createPackage({
    required int branchId,
    required CreatePackageRequest request,
  }) async {
    final response = await networkService.postData(
      endPoint: EndPoints.createPackage(branchId),
      data: request.toJson(),
    );

    return response.fold(
      (failure) => Left(failure.message),
      (data) =>
          Right(CreatePackageResponse.fromJson(data as Map<String, dynamic>)),
    );
  }

  @override
  Future<Either<String, BranchPackagesResponse>> getBranchPackages({
    required int branchId,
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getBranchPackages(branchId),
      queryParameters: {'PageNumber': pageNumber, 'PageSize': pageSize},
    );

    return response.fold(
      (failure) => Left(failure.message),
      (data) =>
          Right(BranchPackagesResponse.fromJson(data as Map<String, dynamic>)),
    );
  }

  @override
  Future<Either<String, CreatePackageResponse>> updatePackage({
    required int branchId,
    required int packageId,
    required UpdatePackageRequest request,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.updatePackage(branchId, packageId),
      data: request.toJson(),
    );

    return response.fold(
      (failure) => Left(failure),
      (data) =>
          Right(CreatePackageResponse.fromJson(data as Map<String, dynamic>)),
    );
  }

  @override
  Future<Either<String, void>> updatePackageStatus({
    required int branchId,
    required int packageId,
    required bool isActive,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.updatePackageStatus(branchId, packageId),
      data: {'isActive': isActive},
    );
    return response.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<String, void>> deletePackage({
    required int branchId,
    required int packageId,
  }) async {
    final response = await networkService.deleteData(
      endPoint: EndPoints.deletePackage(branchId, packageId),
    );
    return response.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<String, void>> updateBranchDetails({
    required int branchId,
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.updateBranchDetails(branchId),
      data: {
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'branchType': branchType,
      },
    );
    return response.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<String, void>> updateBranchStatus({
    required int branchId,
    required int branchStatus,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.updateBranchStatus(branchId),
      data: {'branchStatus': branchStatus},
    );
    return response.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<String, String>> uploadBranchImage({
    required int branchId,
    required File imageFile,
  }) async {
    final fileName = imageFile.path.split(Platform.pathSeparator).last;

    final formData = FormData.fromMap({
      'ImageFile': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    final response = await networkService.uploadFile(
      endPoint: EndPoints.addBranchImage(branchId),
      formData: formData,
    );

    return response.fold((failure) => Left(failure.message), (data) {
      if (data is Map<String, dynamic>) {
        return Right((data['imageUrl'] ?? '').toString());
      }
      return const Right('');
    });
  }

  @override
  Future<Either<String, String>> updateBranchImage({
    required int branchId,
    required int imageId,
    required File imageFile,
  }) async {
    final fileName = imageFile.path.split(Platform.pathSeparator).last;

    final formData = FormData.fromMap({
      'ImageFile': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    try {
      final response = await networkService.dio.patch(
        EndPoints.updateBranchImage(branchId, imageId),
        data: formData,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 299) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return Right((data['imageUrl'] ?? '').toString());
        }
        return const Right('');
      }

      final data = response.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        return Left(data['message'].toString());
      }
      return Left('Error ${response.statusCode}');
    } on DioException catch (error) {
      final handled = networkService.handleDioExceoptions(error);
      return handled.fold((failure) => Left(failure.message), (_) {
        return Left(error.message ?? 'Request failed');
      });
    } catch (error) {
      return Left(error.toString());
    }
  }
}
