import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:gymbook/core/cache/hive_boxes.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_home/data/datasources/nearby_branches_remote_datasource.dart';
import 'package:gymbook/features/customer/customer_home/data/models/nearby_branches_response_model.dart';
import 'package:gymbook/features/customer/customer_home/domain/entities/nearby_branch_entity.dart';
import 'package:gymbook/features/customer/customer_home/domain/entities/nearby_branches_page_entity.dart';
import 'package:gymbook/features/customer/customer_home/domain/repositories/nearby_branches_repository.dart';

class NearbyBranchesRepositoryImpl implements NearbyBranchesRepository {
  final NearbyBranchesRemoteDataSource remoteDataSource;

  NearbyBranchesRepositoryImpl(this.remoteDataSource);

  static const int _cacheTtlMillis = 5 * 60 * 1000; // 5 minutes TTL

  @override
  Stream<Either<Failure, NearbyBranchesPageEntity>> getNearbyBranches({
    double? latitude,
    double? longitude,
    required int radiusInMeters,
    required int pageNumber,
    required int pageSize,
    String? search,
  }) async* {
    final String cacheKey =
        'nearby_branches_${latitude}_${longitude}_${radiusInMeters}_${pageNumber}_${pageSize}_$search';

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
          final model = NearbyBranchesResponseModel.fromJson(dataMap);
          emittedCache = true;
          yield Right(_mapPage(model));

          // Check TTL
          if (timestamp != null) {
            final now = DateTime.now().millisecondsSinceEpoch;
            if (now - timestamp < _cacheTtlMillis) {
              needsBackgroundRefresh = false;
            }
          }
        }
      } catch (_) {
        // Ignore cache parse errors
      }
    }

    // 2. Fetch from Network
    if (needsBackgroundRefresh) {
      try {
        final remoteModel = await remoteDataSource.getNearbyBranches(
          latitude: latitude,
          longitude: longitude,
          radiusInMeters: radiusInMeters,
          pageNumber: pageNumber,
          pageSize: pageSize,
          search: search,
        );

        final remoteJsonString = jsonEncode(remoteModel.toJson());

        // Retrieve current cache to compare
        bool shouldUpdateCacheAndEmit = true;
        if (emittedCache) {
          final currentCachedJson =
              Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
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
          await Hive.box<String>(HiveBoxes.cacheBox).put(
            cacheKey,
            jsonEncode(newCacheWrapper),
          );
          yield Right(_mapPage(remoteModel));
        }
      } catch (e) {
        // 3. Handle Errors
        if (!emittedCache) {
          if (e is ServerException) {
            yield Left(ServerFailure(message: e.message));
          } else {
            yield Left(ServerFailure(message: e.toString()));
          }
        }
      }
    }
  }

  NearbyBranchesPageEntity _mapPage(NearbyBranchesResponseModel model) {
    return NearbyBranchesPageEntity(
      data: model.data.map(_mapItem).toList(),
      currentPage: model.currentPage,
      totalPages: model.totalPages,
      totalCount: model.totalCount,
      pageSize: model.pageSize,
      hasPreviousPage: model.hasPreviousPage,
      hasNextPage: model.hasNextPage,
    );
  }

  NearbyBranchEntity _mapItem(NearbyBranchItemModel item) {
    return NearbyBranchEntity(
      id: item.id,
      name: item.name,
      branchType: item.branchType,
      logoUrl: item.logoUrl,
      governate: item.governate,
      address: item.address,
      latitude: item.latitude,
      longitude: item.longitude,
      isOpenNow: item.isOpenNow,
      hasDistance: item.hasDistance,
      distanceInMeters: item.distanceInMeters,
      totalRatings: item.totalRatings,
      averageRating: item.averageRating,
    );
  }
}
