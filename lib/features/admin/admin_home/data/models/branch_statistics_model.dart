class BranchStatisticsModel {
  final int branchId;
  final int newSubscriptionsCount;
  final int expiredSubscriptionsCount;
  final double totalRevenue;
  final int checkInsCount;

  BranchStatisticsModel({
    required this.branchId,
    required this.newSubscriptionsCount,
    required this.expiredSubscriptionsCount,
    required this.totalRevenue,
    required this.checkInsCount,
  });

  factory BranchStatisticsModel.fromJson(Map<String, dynamic> json) {
    return BranchStatisticsModel(
      branchId: json['id'] ?? 0,
      newSubscriptionsCount: json['newSubscriptionsCount'] ?? 0,
      expiredSubscriptionsCount: json['expiredSubscriptionsCount'] ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      // API has a typo: "checksInCout" instead of "checksInCount"
      checkInsCount: json['checksInCount'] ?? json['checksInCout'] ?? 0,
    );
  }
}
