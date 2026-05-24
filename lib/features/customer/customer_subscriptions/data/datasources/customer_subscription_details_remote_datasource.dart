import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscription_details_model.dart';

abstract class CustomerSubscriptionDetailsRemoteDataSource {
  Future<CustomerSubscriptionDetailsModel> getDetails({
    required int subscriptionId,
  });
}

class CustomerSubscriptionDetailsRemoteDataSourceImpl
    implements CustomerSubscriptionDetailsRemoteDataSource {
  final NetworkService networkService;

  CustomerSubscriptionDetailsRemoteDataSourceImpl(this.networkService);

  @override
  Future<CustomerSubscriptionDetailsModel> getDetails({
    required int subscriptionId,
  }) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getMySubscriptionDetails(subscriptionId),
    );

    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => CustomerSubscriptionDetailsModel.fromJson(
        data as Map<String, dynamic>,
      ),
    );
  }
}
