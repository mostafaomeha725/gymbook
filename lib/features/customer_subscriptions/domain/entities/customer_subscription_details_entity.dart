class CustomerSubscriptionDetailsEntity {
  final String branchName;
  final String address;
  final double? latitude;
  final double? longitude;
  final List<CustomerSubscriptionImageEntity> images;
  final int subscriptionId;
  final int subscriptionStatus;
  final double price;
  final String activationDate;
  final String endDate;
  final int durationInDays;
  final int checkInsCount;
  final String packageName;

  const CustomerSubscriptionDetailsEntity({
    required this.branchName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.subscriptionId,
    required this.subscriptionStatus,
    required this.price,
    required this.activationDate,
    required this.endDate,
    required this.durationInDays,
    required this.checkInsCount,
    required this.packageName,
  });
}

class CustomerSubscriptionImageEntity {
  final String url;

  const CustomerSubscriptionImageEntity({required this.url});
}
