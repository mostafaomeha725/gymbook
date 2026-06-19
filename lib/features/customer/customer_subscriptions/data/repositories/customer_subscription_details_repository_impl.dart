import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:gymbook/core/cache/hive_boxes.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/datasources/customer_subscription_details_remote_datasource.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscription_details_model.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/entities/customer_subscription_details_entity.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/repositories/customer_subscription_details_repository.dart';

class CustomerSubscriptionDetailsRepositoryImpl
    implements CustomerSubscriptionDetailsRepository {
  final CustomerSubscriptionDetailsRemoteDataSource remoteDataSource;

  CustomerSubscriptionDetailsRepositoryImpl(this.remoteDataSource);

  static const int _cacheTtlMillis = 5 * 60 * 1000; // 5 minutes TTL

  @override
  Stream<Either<Failure, CustomerSubscriptionDetailsEntity>> getDetails({
    required int subscriptionId,
  }) async* {
    final String cacheKey = 'subscription_details_$subscriptionId';
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
          final model = CustomerSubscriptionDetailsModel.fromJson(dataMap);
          emittedCache = true;
          yield Right(model.toEntity());

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
        final remoteModel = await remoteDataSource.getDetails(
          subscriptionId: subscriptionId,
        );

        final remoteJsonString = jsonEncode(remoteModel.toJson());

        // Compare with current cache
        bool shouldUpdateCacheAndEmit = true;
        if (emittedCache) {
          final currentCachedJson =
              Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
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
          await Hive.box<String>(HiveBoxes.cacheBox).put(
            cacheKey,
            jsonEncode(newCacheWrapper),
          );
          yield Right(remoteModel.toEntity());
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
