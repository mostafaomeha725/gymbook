import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/datasources/customer_subscription_details_remote_datasource.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/entities/customer_subscription_details_entity.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/repositories/customer_subscription_details_repository.dart';

class CustomerSubscriptionDetailsRepositoryImpl
    implements CustomerSubscriptionDetailsRepository {
  final CustomerSubscriptionDetailsRemoteDataSource remoteDataSource;

  CustomerSubscriptionDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CustomerSubscriptionDetailsEntity>> getDetails({
    required int subscriptionId,
  }) async {
    try {
      final model = await remoteDataSource.getDetails(
        subscriptionId: subscriptionId,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
