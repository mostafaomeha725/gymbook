import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/add_subscription_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/subscription_repository.dart';

class AddSubscriptionUseCase {
  final SubscriptionRepository repository;
  AddSubscriptionUseCase(this.repository);

  Future<Either<Failure, AddSubscriptionEntity>> call({
    required int branchId,
    required String email,
    required int packageId,
  }) {
    return repository.addSubscription(
      branchId: branchId,
      email: email,
      packageId: packageId,
    );
  }
}
