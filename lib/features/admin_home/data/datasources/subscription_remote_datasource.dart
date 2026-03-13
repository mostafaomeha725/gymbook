import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin_home/data/models/add_member_model.dart';
import 'package:gymbook/features/admin_home/data/models/add_subscription_model.dart';
import 'package:gymbook/features/admin_home/data/models/branch_subscriptions_model.dart';
import 'package:gymbook/features/admin_home/data/models/subscription_details_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<AddSubscriptionModel> addSubscription({
    required int branchId,
    required String email,
    required int packageId,
  });

  Future<AddMemberModel> addMember({
    required int branchId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required int packageId,
  });

  Future<BranchSubscriptionsResponse> getBranchSubscriptions({
    required int branchId,
    required int pageNumber,
    required int pageSize,
    String? search,
    int? status,
  });

  Future<void> cancelSubscription({required int subscriptionId});

  Future<SubscriptionDetailsModel> getSubscriptionDetails(int subscriptionId);
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final NetworkService networkService;

  SubscriptionRemoteDataSourceImpl(this.networkService);

  @override
  Future<AddSubscriptionModel> addSubscription({
    required int branchId,
    required String email,
    required int packageId,
  }) async {
    final response = await networkService.postData(
      endPoint: EndPoints.addSubscription(branchId),
      data: {'email': email, 'packageId': packageId},
    );
    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => AddSubscriptionModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<AddMemberModel> addMember({
    required int branchId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required int packageId,
  }) async {
    final response = await networkService.postData(
      endPoint: EndPoints.addMember(branchId),
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'packageId': packageId,
        'branchId': branchId,
      },
    );
    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => AddMemberModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<BranchSubscriptionsResponse> getBranchSubscriptions({
    required int branchId,
    required int pageNumber,
    required int pageSize,
    String? search,
    int? status,
  }) async {
    final params = <String, dynamic>{
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };
    if (search != null && search.trim().isNotEmpty) {
      params['Search'] = search.trim();
    }
    // Note: Status filtering is done client-side (API does not support it)
    final response = await networkService.getData(
      endPoint: EndPoints.getBranchSubscriptions(branchId),
      queryParameters: params,
    );
    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) =>
          BranchSubscriptionsResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<void> cancelSubscription({required int subscriptionId}) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.cancelSubscription(subscriptionId),
      data: {},
    );
    response.fold((failure) => throw ServerException(failure), (_) => null);
  }

  @override
  Future<SubscriptionDetailsModel> getSubscriptionDetails(
    int subscriptionId,
  ) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getSubscriptionDetails(subscriptionId),
    );
    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => SubscriptionDetailsModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
