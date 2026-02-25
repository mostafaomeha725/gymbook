class BranchListResponse {
  final List<BranchItem> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  BranchListResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory BranchListResponse.fromJson(Map<String, dynamic> json) {
    return BranchListResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BranchItem.fromJson(e as Map<String, dynamic>))
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

class BranchItem {
  final int id;
  final String? name;
  final BranchGovernorate? governorate;
  final String? address;
  final int branchType;
  final String? logo;
  final int branchStatus;
  final int subscriptionsCount;

  BranchItem({
    required this.id,
    this.name,
    this.governorate,
    this.address,
    required this.branchType,
    this.logo,
    required this.branchStatus,
    required this.subscriptionsCount,
  });

  factory BranchItem.fromJson(Map<String, dynamic> json) {
    return BranchItem(
      id: json['id'] ?? 0,
      name: json['name'],
      governorate: json['governorate'] != null
          ? BranchGovernorate.fromJson(
              json['governorate'] as Map<String, dynamic>,
            )
          : null,
      address: json['address'],
      branchType: json['branchType'] ?? 0,
      logo: json['logo'],
      branchStatus: json['branchStatus'] ?? 0,
      subscriptionsCount: json['subscriptionsCount'] ?? 0,
    );
  }

  /// 0=MaleOnly, 1=FemaleOnly, 2=Mixed
  String get branchTypeName {
    const names = ['Male Only', 'Female Only', 'Mixed'];
    return names[branchType.clamp(0, 2)];
  }

  /// 0=Draft, 1=Active, 2=Inactive, 3=Closed
  String get branchStatusName {
    const names = ['Draft', 'Active', 'Inactive', 'Closed'];
    return names[branchStatus.clamp(0, 3)];
  }

  String get displayLocation {
    final parts = [
      if (governorate != null) governorate!.name,
      if (address != null && address!.isNotEmpty) address,
    ];
    return parts.isNotEmpty ? parts.join(', ') : 'No location set';
  }
}

class BranchGovernorate {
  final int id;
  final String name;

  BranchGovernorate({required this.id, required this.name});

  factory BranchGovernorate.fromJson(Map<String, dynamic> json) {
    return BranchGovernorate(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
