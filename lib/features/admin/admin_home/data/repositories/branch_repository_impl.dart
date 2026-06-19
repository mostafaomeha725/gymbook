import 'dart:io';

import 'dart:convert';
import 'package:gymbook/core/cache/hive_boxes.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_statistics_model.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/branch_data.dart'
    as HiveKeys;
import 'package:hive/hive.dart';

import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
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

  BranchRepositoryImpl(this.remoteDataSource);

  Future<void> _invalidateBranchesListCache() async {
    final box = Hive.box<String>(HiveBoxes.cacheBox);
    final keysToDelete = box.keys.where((k) {
      if (k is String) {
        return k.startsWith('branches_page_') ||
            k.startsWith('branch_details_') ||
            k.startsWith('branch_setup_') ||
            k.startsWith('branch_statistics_') ||
            k.startsWith('all_branches_statistics_');
      }
      return false;
    }).toList();
    await box.deleteAll(keysToDelete);
  }

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
      await _invalidateBranchesListCache();
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
      await _invalidateBranchesListCache();
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
      await _invalidateBranchesListCache();
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
      await _invalidateBranchesListCache();
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
      await _invalidateBranchesListCache();
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
    final String cacheKey =
        'branches_page_${pageNumber}_size_${pageSize}_search_${search ?? 'none'}';
    bool emittedCache = false;
    bool needsBackgroundRefresh = true;

    // 1. Emit Cache if valid
    final cachedJson = Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final Map<String, dynamic> wrapper = jsonDecode(cachedJson);
        final int? timestamp = wrapper['timestamp'];
        final Map<String, dynamic>? dataMap = wrapper['data'];

        if (dataMap != null) {
          final model = BranchListResponse.fromJson(dataMap);
          emittedCache = true;
          yield Right(_mapBranchList(model));

          if (timestamp != null) {
            // We do NOT use TTL to bypass background refresh. True SWR always fetches.
          }
        }
      } catch (_) {
        // Ignore cache parse errors
      }
    }

    // 2. Fetch from Network
    if (needsBackgroundRefresh) {
      try {
        final remoteModel = await remoteDataSource.getBranches(
          pageNumber: pageNumber,
          pageSize: pageSize,
          search: search,
        );

        final remoteJsonString = jsonEncode(remoteModel.toJson());

        // Retrieve current cache to compare
        bool shouldUpdateCacheAndEmit = true;
        if (emittedCache) {
          final currentCachedJson = Hive.box<String>(
            HiveBoxes.cacheBox,
          ).get(cacheKey);
          if (currentCachedJson != null && currentCachedJson.isNotEmpty) {
            try {
              final wrapper = jsonDecode(currentCachedJson);
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
          await Hive.box<String>(
            HiveBoxes.cacheBox,
          ).put(cacheKey, jsonEncode(newCacheWrapper));
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
      }
    }
  }

  @override
  Stream<Either<Failure, BranchDetailsEntity>> getBranchDetails(
    int branchId,
  ) async* {
    final String cacheKey = 'branch_details_$branchId';
    bool emittedCache = false;

    // 1. Emit Cache if valid
    final cachedJson = Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final Map<String, dynamic> wrapper = jsonDecode(cachedJson);
        final Map<String, dynamic>? dataMap = wrapper['data'];

        if (dataMap != null) {
          final model = BranchDetailsResponse.fromJson(dataMap);
          emittedCache = true;
          yield Right(_mapBranchDetails(model));
        }
      } catch (_) {}
    }

    // 2. Fetch from Network
    try {
      final remoteModel = await remoteDataSource.getBranchDetails(branchId);
      final remoteJsonString = jsonEncode(remoteModel.toJson());

      // Retrieve current cache to compare
      bool shouldUpdateCacheAndEmit = true;
      if (emittedCache) {
        final currentCachedJson = Hive.box<String>(
          HiveBoxes.cacheBox,
        ).get(cacheKey);
        if (currentCachedJson != null && currentCachedJson.isNotEmpty) {
          try {
            final wrapper = jsonDecode(currentCachedJson);
            final cachedDataString = jsonEncode(wrapper['data']);
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
        await Hive.box<String>(
          HiveBoxes.cacheBox,
        ).put(cacheKey, jsonEncode(newCacheWrapper));
        yield Right(_mapBranchDetails(remoteModel));
      }
    } catch (e) {
      if (!emittedCache) {
        if (e is ServerException) {
          yield Left(ServerFailure(message: e.message));
        } else {
          yield const Left(ServerFailure(message: "Network Error"));
        }
      }
    }
  }

  @override
  Stream<Either<Failure, BranchSetupDetailsEntity>> getBranchSetupDetails(
    int branchId,
  ) async* {
    final String cacheKey = 'branch_setup_$branchId';
    bool emittedCache = false;

    // 1. Emit Cache if valid
    final cachedJson = Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final Map<String, dynamic> wrapper = jsonDecode(cachedJson);
        final Map<String, dynamic>? dataMap = wrapper['data'];

        if (dataMap != null) {
          final model = BranchSetupDetailsResponse.fromJson(dataMap);
          emittedCache = true;
          yield Right(_mapBranchSetupDetails(model));
        }
      } catch (_) {}
    }

    // 2. Fetch from Network
    try {
      final remoteModel = await remoteDataSource.getBranchSetupDetails(
        branchId,
      );
      final remoteJsonString = jsonEncode(remoteModel.toJson());

      // Retrieve current cache to compare
      bool shouldUpdateCacheAndEmit = true;
      if (emittedCache) {
        final currentCachedJson = Hive.box<String>(
          HiveBoxes.cacheBox,
        ).get(cacheKey);
        if (currentCachedJson != null && currentCachedJson.isNotEmpty) {
          try {
            final wrapper = jsonDecode(currentCachedJson);
            final cachedDataString = jsonEncode(wrapper['data']);
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
        await Hive.box<String>(
          HiveBoxes.cacheBox,
        ).put(cacheKey, jsonEncode(newCacheWrapper));
        yield Right(_mapBranchSetupDetails(remoteModel));
      }
    } catch (e) {
      if (!emittedCache) {
        if (e is ServerException) {
          yield Left(ServerFailure(message: e.message));
        } else {
          yield const Left(ServerFailure(message: "Network Error"));
        }
      }
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
  Stream<Either<Failure, BranchStatisticsEntity>> getBranchStatistics({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  }) async* {
    final String cacheKey = 'branch_statistics_${branchId}_${timePeriod.name}';
    bool emittedCache = false;

    // 1. Emit Cache if valid
    final cachedJson = Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final Map<String, dynamic> wrapper = jsonDecode(cachedJson);
        final Map<String, dynamic>? dataMap = wrapper['data'];

        if (dataMap != null) {
          final model = BranchStatisticsModel.fromJson(dataMap);
          emittedCache = true;
          yield Right(
            BranchStatisticsEntity(
              branchId: model.branchId,
              newSubscriptionsCount: model.newSubscriptionsCount,
              expiredSubscriptionsCount: model.expiredSubscriptionsCount,
              totalRevenue: model.totalRevenue,
              checkInsCount: model.checkInsCount,
            ),
          );
        }
      } catch (_) {}
    }

    // 2. Fetch from Network
    try {
      final remoteModel = await remoteDataSource.getBranchStatistics(
        branchId: branchId,
        timePeriod: timePeriod,
      );
      final remoteJsonString = jsonEncode(remoteModel.toJson());

      // Retrieve current cache to compare
      bool shouldUpdateCacheAndEmit = true;
      if (emittedCache) {
        final currentCachedJson = Hive.box<String>(
          HiveBoxes.cacheBox,
        ).get(cacheKey);
        if (currentCachedJson != null && currentCachedJson.isNotEmpty) {
          try {
            final wrapper = jsonDecode(currentCachedJson);
            final cachedDataString = jsonEncode(wrapper['data']);
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
        await Hive.box<String>(
          HiveBoxes.cacheBox,
        ).put(cacheKey, jsonEncode(newCacheWrapper));
        yield Right(
          BranchStatisticsEntity(
            branchId: remoteModel.branchId,
            newSubscriptionsCount: remoteModel.newSubscriptionsCount,
            expiredSubscriptionsCount: remoteModel.expiredSubscriptionsCount,
            totalRevenue: remoteModel.totalRevenue,
            checkInsCount: remoteModel.checkInsCount,
          ),
        );
      }
    } catch (e) {
      if (!emittedCache) {
        if (e is ServerException) {
          yield Left(ServerFailure(message: e.message));
        } else {
          yield const Left(ServerFailure(message: "Network Error"));
        }
      }
    }
  }

  @override
  Stream<Either<Failure, BranchStatisticsEntity>> getAllBranchesStatistics({
    required StatisticsTimePeriod timePeriod,
  }) async* {
    final String cacheKey = 'all_branches_statistics_${timePeriod.name}';
    bool emittedCache = false;

    // 1. Emit Cache if valid
    final cachedJson = Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final Map<String, dynamic> wrapper = jsonDecode(cachedJson);
        final Map<String, dynamic>? dataMap = wrapper['data'];

        if (dataMap != null) {
          final model = BranchStatisticsModel.fromJson(dataMap);
          emittedCache = true;
          yield Right(
            BranchStatisticsEntity(
              branchId: model.branchId,
              newSubscriptionsCount: model.newSubscriptionsCount,
              expiredSubscriptionsCount: model.expiredSubscriptionsCount,
              totalRevenue: model.totalRevenue,
              checkInsCount: model.checkInsCount,
            ),
          );
        }
      } catch (_) {}
    }

    // 2. Fetch from Network
    try {
      final remoteModel = await remoteDataSource.getAllBranchesStatistics(
        timePeriod: timePeriod,
      );
      final remoteJsonString = jsonEncode(remoteModel.toJson());

      // Retrieve current cache to compare
      bool shouldUpdateCacheAndEmit = true;
      if (emittedCache) {
        final currentCachedJson = Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
        if (currentCachedJson != null && currentCachedJson.isNotEmpty) {
          try {
            final wrapper = jsonDecode(currentCachedJson);
            final cachedDataString = jsonEncode(wrapper['data']);
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
        await Hive.box<String>(HiveBoxes.cacheBox).put(cacheKey, jsonEncode(newCacheWrapper));
        yield Right(
          BranchStatisticsEntity(
            branchId: remoteModel.branchId,
            newSubscriptionsCount: remoteModel.newSubscriptionsCount,
            expiredSubscriptionsCount: remoteModel.expiredSubscriptionsCount,
            totalRevenue: remoteModel.totalRevenue,
            checkInsCount: remoteModel.checkInsCount,
          ),
        );
      }
    } catch (e) {
      if (!emittedCache) {
        if (e is ServerException) {
          yield Left(ServerFailure(message: e.message));
        } else {
          yield const Left(ServerFailure(message: "Network Error"));
        }
      }
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
