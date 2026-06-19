import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscription_model.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/repositories/customer_subscriptions_repository.dart';

class GetCustomerSubscriptionsUseCase {
  final CustomerSubscriptionsRepository repository;

  GetCustomerSubscriptionsUseCase(this.repository);

  Stream<Either<Failure, List<CustomerSubscriptionModel>>> call({
    int pageNumber = 1,
    int pageSize = 50,
  }) {
    return repository.getMySubscriptions(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
