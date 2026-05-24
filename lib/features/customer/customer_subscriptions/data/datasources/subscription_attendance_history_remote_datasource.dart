import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/subscription_attendance_history_model.dart';

abstract class SubscriptionAttendanceHistoryRemoteDataSource {
  Future<SubscriptionAttendanceHistoryModel> getAttendanceHistory({
    required int subscriptionId,
    int? year,
    int? month,
  });
}

class SubscriptionAttendanceHistoryRemoteDataSourceImpl
    implements SubscriptionAttendanceHistoryRemoteDataSource {
  final NetworkService networkService;

  SubscriptionAttendanceHistoryRemoteDataSourceImpl(this.networkService);

  @override
  Future<SubscriptionAttendanceHistoryModel> getAttendanceHistory({
    required int subscriptionId,
    int? year,
    int? month,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (year != null) {
      queryParameters['Year'] = year;
    }
    if (month != null) {
      queryParameters['Month'] = month;
    }

    final response = await networkService.getData(
      endPoint: EndPoints.getSubscriptionAttendanceHistory(subscriptionId),
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => SubscriptionAttendanceHistoryModel.fromJson(
        data as Map<String, dynamic>,
      ),
    );
  }
}
