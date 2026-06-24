class NearbyBranchesResponseModel {
  final List<NearbyBranchItemModel> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  NearbyBranchesResponseModel({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory NearbyBranchesResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final list = rawData is List ? rawData : const [];

    return NearbyBranchesResponseModel(
      data: list
          .whereType<Map>()
          .map(
            (e) => NearbyBranchItemModel.fromJson(Map<String, dynamic>.from(e)),
          )
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

class NearbyBranchItemModel {
  final int id;
  final String name;
  final int branchType;
  final String logoUrl;
  final String governate;
  final String? address;
  final double latitude;
  final double longitude;
  final bool isOpenNow;
  final bool hasDistance;
  final int distanceInMeters;
  final int totalRatings;
  final double averageRating;

  NearbyBranchItemModel({
    required this.id,
    required this.name,
    required this.branchType,
    required this.logoUrl,
    required this.governate,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isOpenNow,
    required this.hasDistance,
    required this.distanceInMeters,
    required this.totalRatings,
    required this.averageRating,
  });

  factory NearbyBranchItemModel.fromJson(Map<String, dynamic> json) {
    final rawDistance = json['distanceInMeters'];
    final distance = _asInt(rawDistance);
    
    final bool hasDistance;
    if (json.containsKey('hasDistance') && json['hasDistance'] != null) {
      hasDistance = _asBool(json['hasDistance']);
    } else {
      hasDistance = rawDistance != null;
    }

    final hasOpenStatus = json.containsKey('isOpenNow');
    final isOpenNow = hasOpenStatus ? _asBool(json['isOpenNow']) : true;

    String logoUrl = (json['logoUrl'] ?? '').toString();
    if (logoUrl.isEmpty) {
      final logo = json['logo'];
      if (logo is String) {
        logoUrl = logo;
      } else if (logo is Map) {
        final logoMap = Map<String, dynamic>.from(logo);
        logoUrl = (logoMap['imageUrl'] ?? logoMap['url'] ?? '').toString();
      }
    }

    return NearbyBranchItemModel(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      branchType: _asInt(json['branchType']),
      logoUrl: logoUrl,
      governate: (json['governate'] ?? json['governorate'] ?? '').toString(),
      address: json['address']?.toString(),
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
      isOpenNow: isOpenNow,
      hasDistance: hasDistance,
      distanceInMeters: distance,
      totalRatings: _asInt(json['totalRatings']),
      averageRating: _asDouble(json['averageRating']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branchType': branchType,
      'logoUrl': logoUrl,
      'governate': governate,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'isOpenNow': isOpenNow,
      'hasDistance': hasDistance,
      'distanceInMeters': distanceInMeters,
      'totalRatings': totalRatings,
      'averageRating': averageRating,
    };
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return 0;
      return int.tryParse(trimmed) ?? (double.tryParse(trimmed)?.toInt() ?? 0);
    }
    return 0;
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }
}
