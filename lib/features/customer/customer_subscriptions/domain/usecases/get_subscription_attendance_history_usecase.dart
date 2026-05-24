import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/entities/subscription_attendance_history_entity.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/repositories/subscription_attendance_history_repository.dart';

class GetSubscriptionAttendanceHistoryUseCase {
  final SubscriptionAttendanceHistoryRepository repository;

  GetSubscriptionAttendanceHistoryUseCase(this.repository);

  Future<Either<Failure, SubscriptionAttendanceHistoryEntity>> call({
    required int subscriptionId,
    int? year,
    int? month,
  }) {
    return repository.getAttendanceHistory(
      subscriptionId: subscriptionId,
      year: year,
      month: month,
    );
  }
}
