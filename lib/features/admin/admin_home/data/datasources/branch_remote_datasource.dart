import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin/admin_home/data/datasources/branch_remote_image_api.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_details_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_setup_details_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_statistics_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/create_branch_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/uploaded_branch_image_model.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_statistics_entity.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_reviews_model.dart';

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

  Future<BranchSetupDetailsResponse> getBranchSetupDetails(int branchId);

  Future<UploadedBranchImageModel> uploadBranchImage({
    required int branchId,
    required File imageFile,
    int? imageType,
    int? displayOrder,
  });

  Future<UploadedBranchImageModel> updateBranchImage({
    required int branchId,
    required int imageId,
    required File imageFile,
  });

  Future<void> activateBranchImages({
    required int branchId,
    required List<int> imageIds,
  });

  Future<BranchStatisticsModel> getBranchStatistics({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  });

  Future<BranchStatisticsModel> getAllBranchesStatistics({
    required StatisticsTimePeriod timePeriod,
  });

  Future<BranchReviewsModel> getBranchReviews({
    required int branchId,
    int pageNumber = 1,
    int pageSize = 10,
    double? rating,
  });
}

class BranchRemoteDataSourceImpl implements BranchRemoteDataSource {
  final NetworkService networkService;
  late final BranchRemoteImageApi _imageApi;

  BranchRemoteDataSourceImpl(this.networkService) {
    _imageApi = BranchRemoteImageApi(networkService);
  }

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
  Future<BranchSetupDetailsResponse> getBranchSetupDetails(int branchId) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getBranchSetupDetails(branchId),
    );
    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) =>
          BranchSetupDetailsResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<UploadedBranchImageModel> uploadBranchImage({
    required int branchId,
    required File imageFile,
    int? imageType,
    int? displayOrder,
  }) async {
    return _imageApi.uploadBranchImage(
      branchId: branchId,
      imageFile: imageFile,
      imageType: imageType,
      displayOrder: displayOrder,
    );
  }

  @override
  Future<UploadedBranchImageModel> updateBranchImage({
    required int branchId,
    required int imageId,
    required File imageFile,
  }) async {
    return _imageApi.updateBranchImage(
      branchId: branchId,
      imageId: imageId,
      imageFile: imageFile,
    );
  }

  @override
  Future<void> activateBranchImages({
    required int branchId,
    required List<int> imageIds,
  }) async {
    await _imageApi.activateBranchImages(
      branchId: branchId,
      imageIds: imageIds,
    );
  }

  @override
  Future<BranchStatisticsModel> getBranchStatistics({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  }) async {
    try {
      final response = await networkService.dio.request(
        EndPoints.getBranchStatistics(branchId),
        queryParameters: timePeriod.value != null
            ? {'timePeriod': timePeriod.value}
            : null,
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

  @override
  Future<BranchStatisticsModel> getAllBranchesStatistics({
    required StatisticsTimePeriod timePeriod,
  }) async {
    try {
      final response = await networkService.dio.request(
        EndPoints.getAllBranchesStatistics,
        queryParameters: timePeriod.value != null
            ? {'timePeriod': timePeriod.value}
            : null,
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

  @override
  Future<BranchReviewsModel> getBranchReviews({
    required int branchId,
    int pageNumber = 1,
    int pageSize = 10,
    double? rating,
  }) async {
    try {
      final queryParams = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };
      if (rating != null) {
        queryParams['rating'] = rating.toInt();
      }

      final response = await networkService.dio.request(
        EndPoints.getBranchReviews(branchId),
        queryParameters: queryParams,
        options: Options(method: 'GET', contentType: Headers.jsonContentType),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw ServerException('Invalid reviews response format');
      }

      return BranchReviewsModel.fromJson(data);
    } on DioException catch (error) {
      final handled = networkService.handleDioExceoptions(error);
      return handled.fold(
        (failure) => throw ServerException(failure.message),
        (_) => throw ServerException(error.message ?? 'Request failed'),
      );
    }
  }
}
