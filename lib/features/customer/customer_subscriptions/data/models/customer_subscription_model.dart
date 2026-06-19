class CustomerSubscriptionModel {
  final int status;
  final int totalDurationInDays;
  final int daysLeft;
  final String branchLogoUrl;
  final String branchName;
  final String packageName;
  final int subscriptionId;

  const CustomerSubscriptionModel({
    required this.status,
    required this.totalDurationInDays,
    required this.daysLeft,
    required this.branchLogoUrl,
    required this.branchName,
    required this.packageName,
    required this.subscriptionId,
  });

  factory CustomerSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return CustomerSubscriptionModel(
      status: _asInt(json['status']),
      totalDurationInDays: _asInt(json['totalDurationInDays']),
      daysLeft: _asInt(json['daysLeft']),
      branchLogoUrl: (json['branchLogoUrl'] ?? '').toString(),
      branchName: (json['branchName'] ?? '').toString(),
      packageName: (json['packageName'] ?? '').toString(),
      subscriptionId: _asInt(json['subscriptionId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalDurationInDays': totalDurationInDays,
      'daysLeft': daysLeft,
      'branchLogoUrl': branchLogoUrl,
      'branchName': branchName,
      'packageName': packageName,
      'subscriptionId': subscriptionId,
    };
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
