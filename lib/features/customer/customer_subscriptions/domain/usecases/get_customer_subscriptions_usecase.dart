import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscriptions_page_model.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/repositories/customer_subscriptions_repository.dart';

class GetCustomerSubscriptionsUseCase {
  final CustomerSubscriptionsRepository repository;

  GetCustomerSubscriptionsUseCase(this.repository);

  Stream<Either<Failure, CustomerSubscriptionsPageModel>> call({
    int pageNumber = 1,
    int pageSize = 5,
    int? status,
  }) {
    return repository.getMySubscriptions(
      pageNumber: pageNumber,
      pageSize: pageSize,
      status: status,
    );
  }
}
