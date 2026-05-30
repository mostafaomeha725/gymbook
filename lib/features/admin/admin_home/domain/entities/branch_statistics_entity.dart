enum StatisticsTimePeriod {
  today(0),
  thisWeek(1),
  thisMonth(2),
  all(null);

  final int? value;
  const StatisticsTimePeriod(this.value);
}

class BranchStatisticsEntity {
  final int branchId;
  final int newSubscriptionsCount;
  final int expiredSubscriptionsCount;
  final double totalRevenue;
  final int checkInsCount;

  const BranchStatisticsEntity({
    required this.branchId,
    required this.newSubscriptionsCount,
    required this.expiredSubscriptionsCount,
    required this.totalRevenue,
    required this.checkInsCount,
  });
}
