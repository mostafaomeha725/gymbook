import 'package:gymbook/features/customer_subscriptions/domain/entities/subscription_attendance_history_entity.dart';

class SubscriptionAttendanceHistoryModel {
  final int subscriptionId;
  final DateTime createdAt;
  final int year;
  final int month;
  final List<int> attendedDays;
  final int totalAttendance;
  final bool hasPreviousMonth;
  final bool hasNextMonth;

  const SubscriptionAttendanceHistoryModel({
    required this.subscriptionId,
    required this.createdAt,
    required this.year,
    required this.month,
    required this.attendedDays,
    required this.totalAttendance,
    required this.hasPreviousMonth,
    required this.hasNextMonth,
  });

  factory SubscriptionAttendanceHistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawDays = (json['attendedDays'] as List<dynamic>? ?? const []);

    return SubscriptionAttendanceHistoryModel(
      subscriptionId: (json['subscriptionId'] as num?)?.toInt() ?? 0,
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      year: (json['year'] as num?)?.toInt() ?? DateTime.now().year,
      month: (json['month'] as num?)?.toInt() ?? DateTime.now().month,
      attendedDays: rawDays
          .map((item) {
            if (item is int) return item;
            if (item is num) return item.toInt();
            return int.tryParse(item.toString()) ?? 0;
          })
          .where((day) => day > 0)
          .toList(),
      totalAttendance: (json['totalAttendance'] as num?)?.toInt() ?? 0,
      hasPreviousMonth: json['hasPreviousMonth'] == true,
      hasNextMonth: json['hasNextMonth'] == true,
    );
  }

  SubscriptionAttendanceHistoryEntity toEntity() {
    return SubscriptionAttendanceHistoryEntity(
      subscriptionId: subscriptionId,
      createdAt: createdAt,
      year: year,
      month: month,
      attendedDays: List<int>.unmodifiable(attendedDays),
      totalAttendance: totalAttendance,
      hasPreviousMonth: hasPreviousMonth,
      hasNextMonth: hasNextMonth,
    );
  }
}
