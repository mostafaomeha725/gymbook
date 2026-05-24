import 'package:gymbook/features/customer/customer_subscriptions/domain/entities/subscription_attendance_history_entity.dart';

abstract class SubscriptionAttendanceHistoryState {}

class SubscriptionAttendanceHistoryInitial
    extends SubscriptionAttendanceHistoryState {}

class SubscriptionAttendanceHistoryLoading
    extends SubscriptionAttendanceHistoryState {}

class SubscriptionAttendanceHistorySuccess
    extends SubscriptionAttendanceHistoryState {
  final SubscriptionAttendanceHistoryEntity history;
  final List<List<bool>> weeks;

  SubscriptionAttendanceHistorySuccess({
    required this.history,
    required this.weeks,
  });
}

class SubscriptionAttendanceHistoryFailure
    extends SubscriptionAttendanceHistoryState {
  final String message;

  SubscriptionAttendanceHistoryFailure(this.message);
}
