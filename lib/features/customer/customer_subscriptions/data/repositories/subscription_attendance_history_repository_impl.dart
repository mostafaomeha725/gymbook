import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/datasources/subscription_attendance_history_remote_datasource.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/entities/subscription_attendance_history_entity.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/repositories/subscription_attendance_history_repository.dart';

class SubscriptionAttendanceHistoryRepositoryImpl
    implements SubscriptionAttendanceHistoryRepository {
  final SubscriptionAttendanceHistoryRemoteDataSource remoteDataSource;

  SubscriptionAttendanceHistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, SubscriptionAttendanceHistoryEntity>>
  getAttendanceHistory({
    required int subscriptionId,
    int? year,
    int? month,
  }) async {
    try {
      final model = await remoteDataSource.getAttendanceHistory(
        subscriptionId: subscriptionId,
        year: year,
        month: month,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
