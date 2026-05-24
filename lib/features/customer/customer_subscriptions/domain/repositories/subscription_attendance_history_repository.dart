import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/entities/subscription_attendance_history_entity.dart';

abstract class SubscriptionAttendanceHistoryRepository {
  Future<Either<Failure, SubscriptionAttendanceHistoryEntity>>
  getAttendanceHistory({required int subscriptionId, int? year, int? month});
}
