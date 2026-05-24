class BranchSetupBusinessDetailsModel {
  final String name;
  final String email;
  final String phoneNumber;
  final int branchType;

  BranchSetupBusinessDetailsModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.branchType,
  });

  factory BranchSetupBusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    return BranchSetupBusinessDetailsModel(
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      branchType: _asInt(json['branchType']) ?? 0,
    );
  }
}

class BranchSetupCoordinatesModel {
  final double? latitude;
  final double? longitude;

  BranchSetupCoordinatesModel({this.latitude, this.longitude});

  factory BranchSetupCoordinatesModel.fromJson(Map<String, dynamic> json) {
    return BranchSetupCoordinatesModel(
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
    );
  }
}

class BranchSetupGovernorateModel {
  final int id;
  final String name;

  BranchSetupGovernorateModel({required this.id, required this.name});

  factory BranchSetupGovernorateModel.fromJson(Map<String, dynamic> json) {
    return BranchSetupGovernorateModel(
      id: _asInt(json['id']) ?? 0,
      name: (json['name'] ?? '').toString(),
    );
  }
}

class BranchSetupLocationModel {
  final BranchSetupGovernorateModel? governorate;
  final String address;
  final BranchSetupCoordinatesModel coordinates;

  BranchSetupLocationModel({
    this.governorate,
    required this.address,
    required this.coordinates,
  });

  factory BranchSetupLocationModel.fromJson(Map<String, dynamic> json) {
    final coordinatesJson = json['coordinates'] as Map<String, dynamic>?;
    return BranchSetupLocationModel(
      governorate: json['governorate'] is Map<String, dynamic>
          ? BranchSetupGovernorateModel.fromJson(
              json['governorate'] as Map<String, dynamic>,
            )
          : null,
      address: (json['address'] ?? '').toString(),
      coordinates: BranchSetupCoordinatesModel.fromJson(
        coordinatesJson ??
            {'latitude': json['latitude'], 'longitude': json['longitude']},
      ),
    );
  }
}

class BranchSetupWorkingHourModel {
  final int day;
  final String? openTime;
  final String? closeTime;
  final bool isClosed;

  BranchSetupWorkingHourModel({
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.isClosed,
  });

  factory BranchSetupWorkingHourModel.fromJson(Map<String, dynamic> json) {
    return BranchSetupWorkingHourModel(
      day: _asInt(json['day']) ?? 0,
      openTime: _asStringOrNull(json['openTime']),
      closeTime: _asStringOrNull(json['closeTime']),
      isClosed: json['isClosed'] == true,
    );
  }
}

class BranchSetupImageModel {
  final int id;
  final int type;
  final String url;
  final int displayOrder;

  BranchSetupImageModel({
    required this.id,
    required this.type,
    required this.url,
    required this.displayOrder,
  });

  factory BranchSetupImageModel.fromJson(Map<String, dynamic> json) {
    return BranchSetupImageModel(
      id: _asInt(json['id']) ?? 0,
      type: _asInt(json['type']) ?? 0,
      url: (json['url'] ?? '').toString(),
      displayOrder: _asInt(json['displayOrder']) ?? 0,
    );
  }
}

class BranchSetupDetailsResponse {
  final BranchSetupBusinessDetailsModel businessDetails;
  final BranchSetupLocationModel location;
  final List<BranchSetupWorkingHourModel> workingHours;
  final List<BranchSetupImageModel> images;

  BranchSetupDetailsResponse({
    required this.businessDetails,
    required this.location,
    required this.workingHours,
    required this.images,
  });

  factory BranchSetupDetailsResponse.fromJson(Map<String, dynamic> json) {
    final businessJson =
        (json['businessDetails'] as Map<String, dynamic>?) ??
        (json['bussinessDetails'] as Map<String, dynamic>?) ??
        (json['bussiness'] as Map<String, dynamic>?) ??
        <String, dynamic>{};

    return BranchSetupDetailsResponse(
      businessDetails: BranchSetupBusinessDetailsModel.fromJson(businessJson),
      location: BranchSetupLocationModel.fromJson(
        (json['location'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      workingHours: ((json['workingHours'] as List<dynamic>?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(BranchSetupWorkingHourModel.fromJson)
          .toList(),
      images: ((json['images'] as List<dynamic>?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(BranchSetupImageModel.fromJson)
          .toList(),
    );
  }
}

double? _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

String? _asStringOrNull(dynamic value) {
  if (value == null) return null;
  final parsed = value.toString().trim();
  return parsed.isEmpty ? null : parsed;
}
