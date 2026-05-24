import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/entities/customer_subscription_details_entity.dart';

abstract class CustomerSubscriptionDetailsRepository {
  Future<Either<Failure, CustomerSubscriptionDetailsEntity>> getDetails({
    required int subscriptionId,
  });
}
