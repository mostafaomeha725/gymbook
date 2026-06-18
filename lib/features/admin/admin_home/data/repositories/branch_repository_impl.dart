import 'dart:io';

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/features/admin/admin_home/data/datasources/branch_remote_datasource.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_details_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_setup_details_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/create_branch_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/uploaded_branch_image_model.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_list_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_setup_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_statistics_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/created_branch_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/governorate_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/uploaded_branch_image_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_reviews_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/branch_repository.dart';

class BranchRepositoryImpl implements BranchRepository {
  final BranchRemoteDataSource remoteDataSource;
  final PreferencesStorage preferencesStorage;

  BranchRepositoryImpl(this.remoteDataSource, this.preferencesStorage);

  static const int _cacheTtlMillis = 5 * 60 * 1000; // 5 minutes TTL

  @override
  Future<Either<Failure, CreatedBranchEntity>> createBranch({
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) async {
    try {
      final model = await remoteDataSource.createBranch(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        branchType: branchType,
      );
      return Right(_mapCreatedBranch(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> editBranch({
    required int branchId,
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) async {
    try {
      await remoteDataSource.editBranch(
        branchId: branchId,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        branchType: branchType,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateBranchWorkingHours({
    required int branchId,
    required List<Map<String, dynamic>> workingHours,
  }) async {
    try {
      await remoteDataSource.updateBranchWorkingHours(
        branchId: branchId,
        workingHours: workingHours,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateBranchLocationDetails({
    required int branchId,
    required int governorateId,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await remoteDataSource.updateBranchLocationDetails(
        branchId: branchId,
        governorateId: governorateId,
        address: address,
        latitude: latitude,
        longitude: longitude,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateBranchStatus({
    required int branchId,
    required int branchStatus,
  }) async {
    try {
      await remoteDataSource.updateBranchStatus(
        branchId: branchId,
        branchStatus: branchStatus,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Stream<Either<Failure, BranchListEntity>> getBranches({
    int pageNumber = 1,
    int pageSize = 10,
    String? search,
  }) async* {
    final bool isInitialFetch = pageNumber == 1 && (search == null || search.trim().isEmpty);
    bool emittedCache = false;

    // 1. Emit Cache if valid
    if (isInitialFetch) {
      final cachedJson = preferencesStorage.getBranchesList();
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          final Map<String, dynamic> wrapper = jsonDecode(cachedJson);
          final int? timestamp = wrapper['timestamp'];
          final Map<String, dynamic>? dataMap = wrapper['data'];

          if (timestamp != null && dataMap != null) {
            final now = DateTime.now().millisecondsSinceEpoch;
            // Check if cache is not expired
            if (now - timestamp < _cacheTtlMillis) {
              final model = BranchListResponse.fromJson(dataMap);
              emittedCache = true;
              yield Right(_mapBranchList(model));
            }
          }
        } catch (_) {
          // Ignore cache parse errors
        }
      }
    }

    // 2. Fetch from Network
    try {
      final remoteModel = await remoteDataSource.getBranches(
        pageNumber: pageNumber,
        pageSize: pageSize,
        search: search,
      );

      if (isInitialFetch) {
        final remoteJsonString = jsonEncode(remoteModel.toJson());
        
        // Retrieve current cache to compare
        bool shouldUpdateCacheAndEmit = true;
        if (emittedCache) {
          final cachedJsonString = preferencesStorage.getBranchesList();
          if (cachedJsonString != null && cachedJsonString.isNotEmpty) {
            try {
              final wrapper = jsonDecode(cachedJsonString);
              final cachedDataString = jsonEncode(wrapper['data']);
              // If data is identical, we don't need to emit again
              if (remoteJsonString == cachedDataString) {
                shouldUpdateCacheAndEmit = false;
              }
            } catch (_) {}
          }
        }

        if (shouldUpdateCacheAndEmit) {
          final newCacheWrapper = {
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'data': remoteModel.toJson(),
          };
          await preferencesStorage.saveBranchesList(jsonEncode(newCacheWrapper));
          yield Right(_mapBranchList(remoteModel));
        }
      } else {
        // Not initial fetch (pagination or search), just yield remote data
        yield Right(_mapBranchList(remoteModel));
      }
    } catch (e) {
      // 3. Handle Errors
      if (!emittedCache) {
        if (e is ServerException) {
          yield Left(ServerFailure(message: e.message));
        } else {
          yield const Left(ServerFailure(message: "Network Error"));
        }
      }
      // If we already emitted cache, we silently swallow the network error 
      // (or we could emit a specific failure to show a snackbar, but usually SWR hides it)
    }
  }

  @override
  Future<Either<Failure, BranchDetailsEntity>> getBranchDetails(
    int branchId,
  ) async {
    try {
      final model = await remoteDataSource.getBranchDetails(branchId);
      return Right(_mapBranchDetails(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BranchSetupDetailsEntity>> getBranchSetupDetails(
    int branchId,
  ) async {
    try {
      final model = await remoteDataSource.getBranchSetupDetails(branchId);
      return Right(_mapBranchSetupDetails(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UploadedBranchImageEntity>> uploadBranchImage({
    required int branchId,
    required File imageFile,
    int? imageType,
    int? displayOrder,
  }) async {
    try {
      final model = await remoteDataSource.uploadBranchImage(
        branchId: branchId,
        imageFile: imageFile,
        imageType: imageType,
        displayOrder: displayOrder,
      );
      return Right(_mapUploadedImage(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UploadedBranchImageEntity>> updateBranchImage({
    required int branchId,
    required int imageId,
    required File imageFile,
  }) async {
    try {
      final model = await remoteDataSource.updateBranchImage(
        branchId: branchId,
        imageId: imageId,
        imageFile: imageFile,
      );
      return Right(_mapUploadedImage(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> activateBranchImages({
    required int branchId,
    required List<int> imageIds,
  }) async {
    try {
      await remoteDataSource.activateBranchImages(
        branchId: branchId,
        imageIds: imageIds,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BranchStatisticsEntity>> getBranchStatistics({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  }) async {
    try {
      final model = await remoteDataSource.getBranchStatistics(
        branchId: branchId,
        timePeriod: timePeriod,
      );
      return Right(
        BranchStatisticsEntity(
          branchId: model.branchId,
          newSubscriptionsCount: model.newSubscriptionsCount,
          expiredSubscriptionsCount: model.expiredSubscriptionsCount,
          totalRevenue: model.totalRevenue,
          checkInsCount: model.checkInsCount,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BranchStatisticsEntity>> getAllBranchesStatistics({
    required StatisticsTimePeriod timePeriod,
  }) async {
    try {
      final model = await remoteDataSource.getAllBranchesStatistics(
        timePeriod: timePeriod,
      );
      return Right(
        BranchStatisticsEntity(
          branchId: model.branchId,
          newSubscriptionsCount: model.newSubscriptionsCount,
          expiredSubscriptionsCount: model.expiredSubscriptionsCount,
          totalRevenue: model.totalRevenue,
          checkInsCount: model.checkInsCount,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  CreatedBranchEntity _mapCreatedBranch(CreateBranchResponse m) {
    return CreatedBranchEntity(
      id: m.id,
      name: m.name,
      email: m.email,
      phoneNumber: m.phoneNumber,
      branchType: m.branchType,
    );
  }

  GovernorateEntity? _mapGovernorate(BranchGovernorate? m) {
    if (m == null) return null;
    return GovernorateEntity(id: m.id, name: m.name);
  }

  BranchEntity _mapBranchItem(BranchItem m) {
    return BranchEntity(
      id: m.id,
      name: m.name,
      email: m.email,
      phoneNumber: m.phoneNumber,
      governorate: _mapGovernorate(m.governorate),
      address: m.address,
      latitude: m.latitude,
      longitude: m.longitude,
      branchType: m.branchType,
      branchStatus: m.branchStatus,
      logoImageId: m.logoImageId,
      logo: m.logo,
      subscriptionsCount: m.subscriptionsCount,
    );
  }

  BranchListEntity _mapBranchList(BranchListResponse m) {
    return BranchListEntity(
      data: m.data.map(_mapBranchItem).toList(),
      currentPage: m.currentPage,
      totalPages: m.totalPages,
      totalCount: m.totalCount,
      pageSize: m.pageSize,
      hasPreviousPage: m.hasPreviousPage,
      hasNextPage: m.hasNextPage,
    );
  }

  BranchDetailsEntity _mapBranchDetails(BranchDetailsResponse m) {
    return BranchDetailsEntity(
      id: m.id,
      name: m.name,
      branchType: m.branchType,
      branchStatus: m.branchStatus,
      images: m.images
          .map(
            (img) =>
                BranchImageEntity(id: img.id, type: img.type, url: img.url),
          )
          .toList(),
      governorate: _mapGovernorate(m.governorate),
      address: m.address,
      isOpenNow: m.isOpenNow,
      activePackagesCount: m.activePackagesCount,
      activeSubscriptionsCount: m.activeSubscriptionsCount,
    );
  }

  BranchSetupDetailsEntity _mapBranchSetupDetails(
    BranchSetupDetailsResponse model,
  ) {
    return BranchSetupDetailsEntity(
      businessDetails: BranchSetupBusinessDetailsEntity(
        name: model.businessDetails.name,
        email: model.businessDetails.email,
        phoneNumber: model.businessDetails.phoneNumber,
        branchType: model.businessDetails.branchType,
      ),
      location: BranchSetupLocationEntity(
        governorate: model.location.governorate == null
            ? null
            : BranchSetupGovernorateEntity(
                id: model.location.governorate!.id,
                name: model.location.governorate!.name,
              ),
        address: model.location.address,
        coordinates: BranchSetupCoordinatesEntity(
          latitude: model.location.coordinates.latitude,
          longitude: model.location.coordinates.longitude,
        ),
      ),
      workingHours: model.workingHours
          .map(
            (item) => BranchSetupWorkingHourEntity(
              day: item.day,
              openTime: item.openTime,
              closeTime: item.closeTime,
              isClosed: item.isClosed,
            ),
          )
          .toList(),
      images: model.images
          .map(
            (item) => BranchSetupImageEntity(
              id: item.id,
              type: item.type,
              url: item.url,
              displayOrder: item.displayOrder,
            ),
          )
          .toList(),
    );
  }

  UploadedBranchImageEntity _mapUploadedImage(UploadedBranchImageModel model) {
    return model.toEntity();
  }

  @override
  Future<Either<Failure, BranchReviewsEntity>> getBranchReviews({
    required int branchId,
    int pageNumber = 1,
    int pageSize = 10,
    double? rating,
  }) async {
    try {
      final model = await remoteDataSource.getBranchReviews(
        branchId: branchId,
        pageNumber: pageNumber,
        pageSize: pageSize,
        rating: rating,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
