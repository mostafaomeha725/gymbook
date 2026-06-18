import 'package:gymbook/features/admin/admin_home/domain/entities/branch_entity.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalCount': totalCount,
      'pageSize': pageSize,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }
}

class BranchItem {
  final int id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final BranchGovernorate? governorate;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int branchType;
  final int? logoImageId;
  final String? logo;
  final int branchStatus;
  final int subscriptionsCount;

  BranchItem({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.governorate,
    this.address,
    this.latitude,
    this.longitude,
    required this.branchType,
    this.logoImageId,
    this.logo,
    required this.branchStatus,
    required this.subscriptionsCount,
  });

  factory BranchItem.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    final coordinates = location?['coordinates'] as Map<String, dynamic>?;
    final governorateJson =
        (location?['governorate'] ?? json['governorate'])
            as Map<String, dynamic>?;

    return BranchItem(
      id: json['id'] ?? 0,
      name: json['name'],
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      governorate: governorateJson != null
          ? BranchGovernorate.fromJson(governorateJson)
          : null,
      address: (location?['address'] ?? json['address']) as String?,
      latitude: _asDouble(coordinates?['latitude']),
      longitude: _asDouble(coordinates?['longitude']),
      branchType: json['branchType'] ?? 0,
      logoImageId: _asInt(json['logoImageId']) ?? _asLogoImageId(json['logo']),
      logo: _asLogoUrl(json['logoUrl']) ?? _asLogoUrl(json['logo']),
      branchStatus: json['branchStatus'] ?? 0,
      subscriptionsCount: json['subscriptionsCount'] ?? 0,
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static String? _asLogoUrl(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final normalized = value.trim();
      return normalized.isEmpty ? null : normalized;
    }
    if (value is Map<String, dynamic>) {
      final imageUrl = value['imageUrl'];
      if (imageUrl is String) {
        final normalized = imageUrl.trim();
        if (normalized.isNotEmpty) return normalized;
      }

      final url = value['url'];
      if (url is String) {
        final normalized = url.trim();
        if (normalized.isNotEmpty) return normalized;
      }
    }
    return null;
  }

  static int? _asLogoImageId(dynamic value) {
    if (value is Map<String, dynamic>) {
      final imageId = value['imageId'];
      if (imageId is int) return imageId;
      if (imageId is String) return int.tryParse(imageId);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': {
        'address': address,
        'coordinates': {
          'latitude': latitude,
          'longitude': longitude,
        },
        'governorate': governorate?.toJson(),
      },
      'branchType': branchType,
      'logoImageId': logoImageId,
      'logoUrl': logo,
      'branchStatus': branchStatus,
      'subscriptionsCount': subscriptionsCount,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class BranchScreenArgs {
  final int branchId;
  final bool isEditMode;
  final BranchEntity? branch;

  const BranchScreenArgs({
    required this.branchId,
    this.isEditMode = false,
    this.branch,
  });
}
