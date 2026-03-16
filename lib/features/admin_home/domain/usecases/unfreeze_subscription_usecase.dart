import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/repositories/subscription_repository.dart';

class UnfreezeSubscriptionUseCase {
  final SubscriptionRepository repository;
  UnfreezeSubscriptionUseCase(this.repository);

  Future<Either<Failure, void>> call({required int subscriptionId}) {
    return repository.unfreezeSubscription(subscriptionId: subscriptionId);
  }
}
