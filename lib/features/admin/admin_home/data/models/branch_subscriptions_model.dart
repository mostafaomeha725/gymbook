import 'package:gymbook/features/admin/admin_home/domain/entities/subscription_item_entity.dart';

class SubscriptionItemModel {
  final int subscriptionId;
  final String fullName;
  final int status;
  final int totalDurationInDays;
  final int remainingDurationInDays;

  SubscriptionItemModel({
    required this.subscriptionId,
    required this.fullName,
    required this.status,
    required this.totalDurationInDays,
    required this.remainingDurationInDays,
  });

  factory SubscriptionItemModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionItemModel(
      subscriptionId: json['subscriptionId'] ?? 0,
      fullName: json['fullName'] ?? '',
      status: json['status'] ?? 0,
      totalDurationInDays: json['totalDurationInDays'] ?? 0,
      remainingDurationInDays: json['remainingDurationInDays'] ?? 0,
    );
  }

  SubscriptionItemEntity toEntity() {
    return SubscriptionItemEntity(
      subscriptionId: subscriptionId,
      fullName: fullName,
      status: SubscriptionStatus.fromInt(status),
      totalDurationInDays: totalDurationInDays,
      remainingDurationInDays: remainingDurationInDays,
    );
  }
}

class BranchSubscriptionsResponse {
  final List<SubscriptionItemModel> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  BranchSubscriptionsResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory BranchSubscriptionsResponse.fromJson(Map<String, dynamic> json) {
    return BranchSubscriptionsResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SubscriptionItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalCount: json['totalCount'] ?? 0,
      pageSize: json['pageSize'] ?? 10,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}
