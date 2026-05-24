import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/add_member_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/add_subscription_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/subscription_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/subscription_item_entity.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, AddSubscriptionEntity>> addSubscription({
    required int branchId,
    required String email,
    required int packageId,
  });

  Future<Either<Failure, AddMemberEntity>> addMember({
    required int branchId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required int packageId,
  });

  Future<Either<Failure, SubscriptionsListEntity>> getBranchSubscriptions({
    required int branchId,
    required int pageNumber,
    required int pageSize,
    String? search,
    int? status,
  });

  Future<Either<Failure, void>> cancelSubscription({
    required int subscriptionId,
  });

  Future<Either<Failure, void>> freezeSubscription({
    required int subscriptionId,
  });

  Future<Either<Failure, void>> unfreezeSubscription({
    required int subscriptionId,
  });

  Future<Either<Failure, SubscriptionDetailsEntity>> getSubscriptionDetails(
    int subscriptionId,
  );
}
