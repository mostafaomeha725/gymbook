import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin_home/data/models/branch_details_model.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/data/models/branch_statistics_model.dart';
import 'package:gymbook/features/admin_home/data/models/create_branch_model.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_statistics_entity.dart';

abstract class BranchRemoteDataSource {
  Future<CreateBranchResponse> createBranch({
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  });

  Future<void> editBranch({
    required int branchId,
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  });

  Future<void> updateBranchWorkingHours({
    required int branchId,
    required List<Map<String, dynamic>> workingHours,
  });

  Future<void> updateBranchLocationDetails({
    required int branchId,
    required int governorateId,
    required String address,
    required double latitude,
    required double longitude,
  });

  Future<void> updateBranchStatus({
    required int branchId,
    required int branchStatus,
  });

  Future<BranchListResponse> getBranches({
    required int pageNumber,
    required int pageSize,
    String? search,
  });

  Future<BranchDetailsResponse> getBranchDetails(int branchId);

  Future<String> uploadBranchImage({
    required int branchId,
    required File imageFile,
  });

  Future<String> updateBranchImage({
    required int branchId,
    required int imageId,
    required File imageFile,
  });

  Future<BranchStatisticsModel> getBranchStatistics({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  });
}

class BranchRemoteDataSourceImpl implements BranchRemoteDataSource {
  final NetworkService networkService;

  BranchRemoteDataSourceImpl(this.networkService);

  @override
  Future<CreateBranchResponse> createBranch({
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
      (failure) => throw ServerException(failure.message),
      (data) => CreateBranchResponse.fromJson(data),
    );
  }

  @override
  Future<void> editBranch({
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
    response.fold((failure) => throw ServerException(failure), (_) => null);
  }

  @override
  Future<void> updateBranchWorkingHours({
    required int branchId,
    required List<Map<String, dynamic>> workingHours,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.updateBranchWorkingHours(branchId),
      data: {'workingHours': workingHours},
    );
    response.fold((failure) => throw ServerException(failure), (_) => null);
  }

  @override
  Future<void> updateBranchLocationDetails({
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
    response.fold((failure) => throw ServerException(failure), (_) => null);
  }

  @override
  Future<void> updateBranchStatus({
    required int branchId,
    required int branchStatus,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.updateBranchStatus(branchId),
      data: {'branchStatus': branchStatus},
    );
    response.fold((failure) => throw ServerException(failure), (_) => null);
  }

  @override
  Future<BranchListResponse> getBranches({
    required int pageNumber,
    required int pageSize,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };
    if (search != null && search.trim().isNotEmpty) {
      params['Search'] = search.trim();
    }
    final response = await networkService.getData(
      endPoint: EndPoints.getBranches,
      queryParameters: params,
    );
    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => BranchListResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<BranchDetailsResponse> getBranchDetails(int branchId) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getBranchDetails(branchId),
    );
    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => BranchDetailsResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<String> uploadBranchImage({
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
    return response.fold((failure) => throw ServerException(failure.message), (
      data,
    ) {
      if (data is Map<String, dynamic>) {
        return (data['imageUrl'] ?? '').toString();
      }
      return '';
    });
  }

  @override
  Future<String> updateBranchImage({
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
          return (data['imageUrl'] ?? '').toString();
        }
        return '';
      }
      final data = response.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw ServerException(data['message'].toString());
      }
      throw ServerException('Error ${response.statusCode}');
    } on DioException catch (error) {
      final handled = networkService.handleDioExceoptions(error);
      return handled.fold(
        (failure) => throw ServerException(failure.message),
        (_) => throw ServerException(error.message ?? 'Request failed'),
      );
    }
  }

  @override
  Future<BranchStatisticsModel> getBranchStatistics({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  }) async {
    try {
      final response = await networkService.dio.request(
        EndPoints.getBranchStatistics(branchId),
        data: {'timePeriod': timePeriod.value},
        options: Options(method: 'GET', contentType: Headers.jsonContentType),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw ServerException('Invalid statistics response format');
      }

      final statisticsJson = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;

      return BranchStatisticsModel.fromJson(statisticsJson);
    } on DioException catch (error) {
      final handled = networkService.handleDioExceoptions(error);
      return handled.fold(
        (failure) => throw ServerException(failure.message),
        (_) => throw ServerException(error.message ?? 'Request failed'),
      );
    }
  }
}
