import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/subscription_details_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/subscription_repository.dart';

class GetSubscriptionDetailsUseCase {
  final SubscriptionRepository repository;
  GetSubscriptionDetailsUseCase(this.repository);

  Future<Either<Failure, SubscriptionDetailsEntity>> call(int subscriptionId) {
    return repository.getSubscriptionDetails(subscriptionId);
  }
}
