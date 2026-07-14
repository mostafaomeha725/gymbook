import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscriptions_page_model.dart';

abstract class CustomerSubscriptionsRepository {
  Stream<Either<Failure, CustomerSubscriptionsPageModel>> getMySubscriptions({
    int pageNumber = 1,
    int pageSize = 5,
    int? status,
  });
}
