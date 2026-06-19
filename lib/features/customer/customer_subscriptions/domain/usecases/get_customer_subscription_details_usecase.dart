import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/entities/customer_subscription_details_entity.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/repositories/customer_subscription_details_repository.dart';

class GetCustomerSubscriptionDetailsUseCase {
  final CustomerSubscriptionDetailsRepository repository;

  GetCustomerSubscriptionDetailsUseCase(this.repository);

  Stream<Either<Failure, CustomerSubscriptionDetailsEntity>> call({
    required int subscriptionId,
  }) {
    return repository.getDetails(subscriptionId: subscriptionId);
  }
}
