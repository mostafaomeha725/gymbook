import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscription_model.dart';

class CustomerSubscriptionsPageModel {
  final List<CustomerSubscriptionModel> data;
  final int currentPage;
  final int totalPages;

  CustomerSubscriptionsPageModel({
    required this.data,
    required this.currentPage,
    required this.totalPages,
  });

  factory CustomerSubscriptionsPageModel.fromJson(Map<String, dynamic> json) {
    var list = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map(
          (item) => CustomerSubscriptionModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    int parsedTotalPages = 1;
    int parsedCurrentPage = 1;

    // Check root level
    if (json['totalPages'] != null) {
      parsedTotalPages = _asInt(json['totalPages']);
    } else if (json['TotalPages'] != null) {
      parsedTotalPages = _asInt(json['TotalPages']);
    } else if (json['meta'] != null && json['meta']['totalPages'] != null) {
      parsedTotalPages = _asInt(json['meta']['totalPages']);
    } else if (json['totalCount'] != null || json['TotalCount'] != null) {
      int tc = _asInt(json['totalCount'] ?? json['TotalCount']);
      int ps = _asInt(json['pageSize'] ?? json['PageSize']);
      if (ps == 0) ps = 5;
      parsedTotalPages = (tc / ps).ceil();
    }

    if (json['currentPage'] != null) {
      parsedCurrentPage = _asInt(json['currentPage']);
    } else if (json['CurrentPage'] != null) {
      parsedCurrentPage = _asInt(json['CurrentPage']);
    } else if (json['meta'] != null && json['meta']['currentPage'] != null) {
      parsedCurrentPage = _asInt(json['meta']['currentPage']);
    }

    // Fallback: If backend returns all items without pagination, paginate locally
    int pageSize = _asInt(json['pageSize'] ?? json['PageSize']);
    if (pageSize == 0) pageSize = 5;

    if (parsedTotalPages <= 1 && list.length > pageSize) {
      parsedTotalPages = (list.length / pageSize).ceil();
      // Slice the list for the current page manually
      int startIndex = (parsedCurrentPage - 1) * pageSize;
      int endIndex = startIndex + pageSize;
      if (startIndex < list.length) {
        list = list.sublist(
          startIndex,
          endIndex > list.length ? list.length : endIndex,
        );
      } else {
        list = [];
      }
    } else if (parsedTotalPages <= 1 && list.length == pageSize) {
      // It's possible there is a second page, but backend didn't give totalPages.
      // We can't know for sure without fetching next page. We will trust the API or assume 1 page.
    }

    return CustomerSubscriptionsPageModel(
      data: list,
      currentPage: parsedCurrentPage,
      totalPages: parsedTotalPages == 0 ? 1 : parsedTotalPages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
