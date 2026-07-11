import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscription_model.dart';

abstract class CustomerSubscriptionsRemoteDataSource {
  Future<List<CustomerSubscriptionModel>> getMySubscriptions({
    int pageNumber = 1,
    int pageSize = 5,
  });
}

class CustomerSubscriptionsRemoteDataSourceImpl
    implements CustomerSubscriptionsRemoteDataSource {
  final NetworkService networkService;

  CustomerSubscriptionsRemoteDataSourceImpl(this.networkService);

  @override
  Future<List<CustomerSubscriptionModel>> getMySubscriptions({
    int pageNumber = 1,
    int pageSize = 5,
  }) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getMySubscriptions,
      queryParameters: {'PageNumber': pageNumber, 'PageSize': pageSize},
    );

    return response.fold((failure) => throw ServerException(failure.message), (
      data,
    ) {
      final map = data as Map<String, dynamic>;
      final list = (map['data'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (item) => CustomerSubscriptionModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
      return list;
    });
  }
}
