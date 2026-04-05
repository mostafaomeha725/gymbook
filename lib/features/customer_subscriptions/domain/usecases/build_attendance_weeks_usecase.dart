import 'package:gymbook/features/customer_subscriptions/domain/entities/subscription_attendance_history_entity.dart';

class BuildAttendanceWeeksUseCase {
  const BuildAttendanceWeeksUseCase();

  List<List<bool>> call(SubscriptionAttendanceHistoryEntity history) {
    final year = history.year;
    final month = history.month.clamp(1, 12);

    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leadingCells = firstDay.weekday % 7;
    final totalCells = leadingCells + daysInMonth;
    final weeksCount = (totalCells + 6) ~/ 7;

    final normalizedDays = history.attendedDays
        .where((day) => day >= 1 && day <= daysInMonth)
        .toSet();

    return List.generate(weeksCount, (weekIndex) {
      return List.generate(7, (dayIndex) {
        final absoluteCell = (weekIndex * 7) + dayIndex;
        final dayOfMonth = absoluteCell - leadingCells + 1;

        if (dayOfMonth < 1 || dayOfMonth > daysInMonth) {
          return false;
        }

        return normalizedDays.contains(dayOfMonth);
      });
    });
  }
}
