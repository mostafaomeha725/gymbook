import 'package:gymbook/features/admin/admin_home/data/models/branch_package_item.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_packages_meta.dart';

class BranchPackagesResponse {
  final List<BranchPackageItem> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final BranchPackagesMeta meta;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  BranchPackagesResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.meta,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory BranchPackagesResponse.fromJson(Map<String, dynamic> json) {
    return BranchPackagesResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (item) => BranchPackageItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalCount: json['totalCount'] ?? 0,
      meta: BranchPackagesMeta.fromJson(
        json['meta'] as Map<String, dynamic>? ?? {},
      ),
      pageSize: json['pageSize'] ?? 10,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalCount': totalCount,
      'meta': meta.toJson(),
      'pageSize': pageSize,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }
}
