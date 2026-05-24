enum SubscriptionStatus {
  scheduled(0),
  active(1),
  frozen(2),
  expired(3),
  cancelled(4);

  final int value;
  const SubscriptionStatus(this.value);

  static SubscriptionStatus fromInt(int value) {
    return SubscriptionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SubscriptionStatus.active,
    );
  }

  String get displayName {
    switch (this) {
      case SubscriptionStatus.scheduled:
        return 'Scheduled';
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.frozen:
        return 'Frozen';
      case SubscriptionStatus.expired:
        return 'Expired';
      case SubscriptionStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class SubscriptionItemEntity {
  final int subscriptionId;
  final String fullName;
  final SubscriptionStatus status;
  final int totalDurationInDays;
  final int remainingDurationInDays;

  const SubscriptionItemEntity({
    required this.subscriptionId,
    required this.fullName,
    required this.status,
    required this.totalDurationInDays,
    required this.remainingDurationInDays,
  });
}

class SubscriptionsListEntity {
  final List<SubscriptionItemEntity> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const SubscriptionsListEntity({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
}
