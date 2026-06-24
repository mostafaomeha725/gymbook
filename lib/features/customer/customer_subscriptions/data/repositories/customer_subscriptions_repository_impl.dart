import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:gymbook/core/cache/hive_boxes.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/datasources/customer_subscriptions_remote_datasource.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscription_model.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/repositories/customer_subscriptions_repository.dart';

class CustomerSubscriptionsRepositoryImpl
    implements CustomerSubscriptionsRepository {
  final CustomerSubscriptionsRemoteDataSource remoteDataSource;

  CustomerSubscriptionsRepositoryImpl(this.remoteDataSource);

  static const int _cacheTtlMillis = 5 * 60 * 1000; // 5 minutes TTL

  @override
  Stream<Either<Failure, List<CustomerSubscriptionModel>>> getMySubscriptions({
    int pageNumber = 1,
    int pageSize = 50,
  }) async* {
    final String cacheKey = 'customer_subscriptions_${pageNumber}_$pageSize';
    bool emittedCache = false;
    bool needsBackgroundRefresh = true;

    // 1. Emit Cache if valid
    final cachedJson = Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final Map<String, dynamic> wrapper = jsonDecode(cachedJson);
        final List<dynamic>? dataList = wrapper['data'];

        if (dataList != null) {
          final list = dataList
              .whereType<Map<String, dynamic>>()
              .map((e) => CustomerSubscriptionModel.fromJson(e))
              .toList();
          emittedCache = true;
          yield Right(list);

          // Always refresh in the background (Silent refresh)
          needsBackgroundRefresh = true;
        }
      } catch (_) {
        // Ignore cache parse errors
      }
    }

    // 2. Fetch from Network
    if (needsBackgroundRefresh) {
      try {
        final remoteModels = await remoteDataSource.getMySubscriptions(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        final remoteJsonString = jsonEncode(
          remoteModels.map((e) => e.toJson()).toList(),
        );

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
            'data': remoteModels.map((e) => e.toJson()).toList(),
          };
          await Hive.box<String>(
            HiveBoxes.cacheBox,
          ).put(cacheKey, jsonEncode(newCacheWrapper));
          yield Right(remoteModels);
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
