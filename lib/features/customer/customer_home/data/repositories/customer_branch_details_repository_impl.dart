import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:gymbook/core/cache/hive_boxes.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_home/data/datasources/customer_branch_details_remote_datasource.dart';
import 'package:gymbook/features/customer/customer_home/data/models/customer_branch_details_model.dart';
import 'package:gymbook/features/customer/customer_home/domain/repositories/customer_branch_details_repository.dart';

class CustomerBranchDetailsRepositoryImpl
    implements CustomerBranchDetailsRepository {
  final CustomerBranchDetailsRemoteDataSource remoteDataSource;

  CustomerBranchDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Stream<Either<Failure, CustomerBranchDetailsModel>> getBranchDetails({
    required int branchId,
  }) async* {
    final String cacheKey = 'customer_branch_details_$branchId';
    bool emittedCache = false;
    bool needsBackgroundRefresh = true;

    // 1. Emit Cache if valid
    final cachedJson = Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final Map<String, dynamic> wrapper = jsonDecode(cachedJson);
        final Map<String, dynamic>? dataMap = wrapper['data'];

        if (dataMap != null) {
          final model = CustomerBranchDetailsModel.fromJson(dataMap);
          emittedCache = true;
          yield Right(model);
        }
      } catch (_) {
        // Ignore cache parse errors
      }
    }

    // 2. Fetch from Network
    if (needsBackgroundRefresh) {
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
          yield Right(remoteModel);
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
}
