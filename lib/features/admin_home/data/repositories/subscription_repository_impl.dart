import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/data/datasources/subscription_remote_datasource.dart';
import 'package:gymbook/features/admin_home/data/models/branch_subscriptions_model.dart';
import 'package:gymbook/features/admin_home/domain/entities/add_member_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/add_subscription_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/subscription_details_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/subscription_item_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;

  SubscriptionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AddSubscriptionEntity>> addSubscription({
    required int branchId,
    required String email,
    required int packageId,
  }) async {
    try {
      final model = await remoteDataSource.addSubscription(
        branchId: branchId,
        email: email,
        packageId: packageId,
      );
      return Right(AddSubscriptionEntity(id: model.id));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, AddMemberEntity>> addMember({
    required int branchId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required int packageId,
  }) async {
    try {
      final model = await remoteDataSource.addMember(
        branchId: branchId,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        email: email,
        packageId: packageId,
      );
      return Right(AddMemberEntity(id: model.id));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SubscriptionsListEntity>> getBranchSubscriptions({
    required int branchId,
    required int pageNumber,
    required int pageSize,
    String? search,
    int? status,
  }) async {
    try {
      final model = await remoteDataSource.getBranchSubscriptions(
        branchId: branchId,
        pageNumber: pageNumber,
        pageSize: pageSize,
        search: search,
        status: status,
      );
      return Right(_mapSubscriptionsList(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> cancelSubscription({
    required int subscriptionId,
  }) async {
    try {
      await remoteDataSource.cancelSubscription(subscriptionId: subscriptionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> freezeSubscription({
    required int subscriptionId,
  }) async {
    try {
      await remoteDataSource.freezeSubscription(subscriptionId: subscriptionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> unfreezeSubscription({
    required int subscriptionId,
  }) async {
    try {
      await remoteDataSource.unfreezeSubscription(
        subscriptionId: subscriptionId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SubscriptionDetailsEntity>> getSubscriptionDetails(
    int subscriptionId,
  ) async {
    try {
      final model = await remoteDataSource.getSubscriptionDetails(
        subscriptionId,
      );
      return Right(
        SubscriptionDetailsEntity(
          subscriptionId: model.subscriptionId,
          activationDate: DateTime.parse(model.activationDate),
          expirationDate: DateTime.parse(model.expirationDate),
          durationInMonths: model.durationInMonths,
          remainingDays: model.remainingDays,
          paidAmount: model.paidAmount,
          status: model.status,
          packageName: model.packageName,
          totalFreezesCount: model.totalFreezesCount,
          remainingFreezesCount: model.remainingFreezesCount,
          member: SubscriptionMemberEntity(
            fullName: model.member.fullName,
            email: model.member.email,
            phoneNumber: model.member.phoneNumber,
          ),
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  SubscriptionsListEntity _mapSubscriptionsList(BranchSubscriptionsResponse m) {
    return SubscriptionsListEntity(
      data: m.data.map((item) => item.toEntity()).toList(),
      currentPage: m.currentPage,
      totalPages: m.totalPages,
      totalCount: m.totalCount,
      pageSize: m.pageSize,
      hasPreviousPage: m.hasPreviousPage,
      hasNextPage: m.hasNextPage,
    );
  }
}
