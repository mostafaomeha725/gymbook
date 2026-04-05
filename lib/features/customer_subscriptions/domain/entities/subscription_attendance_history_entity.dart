class SubscriptionAttendanceHistoryEntity {
  final int subscriptionId;
  final DateTime createdAt;
  final int year;
  final int month;
  final List<int> attendedDays;
  final int totalAttendance;
  final bool hasPreviousMonth;
  final bool hasNextMonth;

  const SubscriptionAttendanceHistoryEntity({
    required this.subscriptionId,
    required this.createdAt,
    required this.year,
    required this.month,
    required this.attendedDays,
    required this.totalAttendance,
    required this.hasPreviousMonth,
    required this.hasNextMonth,
  });
}
