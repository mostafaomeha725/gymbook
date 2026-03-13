class SubscriptionMemberModel {
  final String fullName;
  final String email;
  final String phoneNumber;

  SubscriptionMemberModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  factory SubscriptionMemberModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionMemberModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}

class SubscriptionDetailsModel {
  final int subscriptionId;
  final String createdAt;
  final String activationDate;
  final String expirationDate;
  final int durationInMonths;
  final int remainingDays;
  final double paidAmount;
  final int status;
  final String packageName;
  final int totalFreezesCount;
  final int remainingFreezesCount;
  final SubscriptionMemberModel member;

  SubscriptionDetailsModel({
    required this.subscriptionId,
    required this.createdAt,
    required this.activationDate,
    required this.expirationDate,
    required this.durationInMonths,
    required this.remainingDays,
    required this.paidAmount,
    required this.status,
    required this.packageName,
    required this.totalFreezesCount,
    required this.remainingFreezesCount,
    required this.member,
  });

  factory SubscriptionDetailsModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetailsModel(
      subscriptionId: json['subscriptionId'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      activationDate: json['activationDate'] ?? '',
      expirationDate: json['expirationDate'] ?? '',
      durationInMonths: json['durationInMonths'] ?? 0,
      remainingDays: json['remainingDays'] ?? 0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 0,
      packageName: json['packageName'] ?? '',
      totalFreezesCount: json['totalFreezesCount'] ?? 0,
      remainingFreezesCount: json['remainingFreezesCount'] ?? 0,
      member: SubscriptionMemberModel.fromJson(
        json['member'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
