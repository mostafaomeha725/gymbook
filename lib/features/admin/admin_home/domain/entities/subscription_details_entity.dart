class SubscriptionMemberEntity {
  final String fullName;
  final String email;
  final String phoneNumber;

  const SubscriptionMemberEntity({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });
}

class SubscriptionDetailsEntity {
  final int subscriptionId;
  final DateTime activationDate;
  final DateTime expirationDate;
  final int durationInMonths;
  final int remainingDays;
  final double paidAmount;
  final int status;
  final String packageName;
  final int totalFreezesCount;
  final int remainingFreezesCount;
  final SubscriptionMemberEntity member;

  const SubscriptionDetailsEntity({
    required this.subscriptionId,
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

  int get totalDays => expirationDate.difference(activationDate).inDays;
}
