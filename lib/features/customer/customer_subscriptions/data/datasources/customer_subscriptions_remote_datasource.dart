import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscriptions_page_model.dart';

abstract class CustomerSubscriptionsRemoteDataSource {
  Future<CustomerSubscriptionsPageModel> getMySubscriptions({
    int pageNumber = 1,
    int pageSize = 5,
    int? status,
  });
}

class CustomerSubscriptionsRemoteDataSourceImpl
    implements CustomerSubscriptionsRemoteDataSource {
  final NetworkService networkService;

  CustomerSubscriptionsRemoteDataSourceImpl(this.networkService);

  @override
  Future<CustomerSubscriptionsPageModel> getMySubscriptions({
    int pageNumber = 1,
    int pageSize = 5,
    int? status,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };

    if (status != null) {
      queryParameters['status'] = status;
    }

    final response = await networkService.getData(
      endPoint: EndPoints.getMySubscriptions,
      queryParameters: queryParameters,
    );

    return response.fold((failure) => throw ServerException(failure.message), (
      data,
    ) {
      return CustomerSubscriptionsPageModel.fromJson(
        data as Map<String, dynamic>,
      );
    });
  }
}
