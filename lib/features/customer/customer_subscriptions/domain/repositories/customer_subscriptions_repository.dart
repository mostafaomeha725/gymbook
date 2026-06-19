import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscription_model.dart';

abstract class CustomerSubscriptionsRepository {
  Stream<Either<Failure, List<CustomerSubscriptionModel>>> getMySubscriptions({
    int pageNumber = 1,
    int pageSize = 50,
  });
}
