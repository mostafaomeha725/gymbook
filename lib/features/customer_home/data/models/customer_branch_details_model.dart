class CustomerBranchDetailsModel {
  final int id;
  final String name;
  final int branchType;
  final bool isOpenNow;
  final List<CustomerBranchImageModel> images;
  final String address;
  final double latitude;
  final double longitude;
  final int totalRatings;
  final double averageRating;
  final List<CustomerWorkingHourModel> workingHours;
  final List<CustomerPackageModel> packages;

  CustomerBranchDetailsModel({
    required this.id,
    required this.name,
    required this.branchType,
    required this.isOpenNow,
    required this.images,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.totalRatings,
    required this.averageRating,
    required this.workingHours,
    required this.packages,
  });

  factory CustomerBranchDetailsModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    final coordinates = location?['coordinates'] as Map<String, dynamic>?;

    return CustomerBranchDetailsModel(
      id: _asInt(json['id']),
      name: (json['name'] ?? '').toString(),
      branchType: _asInt(json['branchType']),
      isOpenNow: _asBool(json['isOpenNow']),
      images: (json['images'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (e) =>
                CustomerBranchImageModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
      address: (location?['address'] ?? '').toString(),
      latitude: _asDouble(coordinates?['latitude']),
      longitude: _asDouble(coordinates?['longitude']),
      totalRatings: _asInt(json['totalRatings']),
      averageRating: _asDouble(json['averageRating']),
      workingHours: (json['workingHours'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (e) =>
                CustomerWorkingHourModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
      packages: (json['packages'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (e) => CustomerPackageModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
    );
  }

  String get branchTypeName {
    switch (branchType) {
      case 0:
        return 'Male';
      case 1:
        return 'Female';
      default:
        return 'Mixed';
    }
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
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

class CustomerBranchImageModel {
  final int id;
  final int type;
  final String url;

  CustomerBranchImageModel({
    required this.id,
    required this.type,
    required this.url,
  });

  factory CustomerBranchImageModel.fromJson(Map<String, dynamic> json) {
    return CustomerBranchImageModel(
      id: json['id'] is int ? json['id'] as int : 0,
      type: json['type'] is int ? json['type'] as int : 0,
      url: (json['url'] ?? '').toString(),
    );
  }
}

class CustomerWorkingHourModel {
  final int day;
  final String openTime;
  final String closeTime;
  final bool isClosed;

  CustomerWorkingHourModel({
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.isClosed,
  });

  factory CustomerWorkingHourModel.fromJson(Map<String, dynamic> json) {
    return CustomerWorkingHourModel(
      day: json['day'] is int ? json['day'] as int : 0,
      openTime: (json['openTime'] ?? '').toString(),
      closeTime: (json['closeTime'] ?? '').toString(),
      isClosed: json['isClosed'] == true,
    );
  }
}

class CustomerPackageModel {
  final int id;
  final String name;
  final double price;
  final int durationInMonths;

  CustomerPackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.durationInMonths,
  });

  factory CustomerPackageModel.fromJson(Map<String, dynamic> json) {
    return CustomerPackageModel(
      id: json['id'] is int ? json['id'] as int : 0,
      name: (json['name'] ?? '').toString(),
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '') ?? 0,
      durationInMonths: json['durationInMonths'] is int
          ? json['durationInMonths'] as int
          : 0,
    );
  }
}
