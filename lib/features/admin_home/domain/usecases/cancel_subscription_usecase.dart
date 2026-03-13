import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/repositories/subscription_repository.dart';

class CancelSubscriptionUseCase {
  final SubscriptionRepository repository;
  CancelSubscriptionUseCase(this.repository);

  Future<Either<Failure, void>> call({required int subscriptionId}) {
    return repository.cancelSubscription(subscriptionId: subscriptionId);
  }
}
