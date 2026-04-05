class BranchSetupBusinessDetailsEntity {
  final String name;
  final String email;
  final String phoneNumber;
  final int branchType;

  const BranchSetupBusinessDetailsEntity({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.branchType,
  });
}

class BranchSetupCoordinatesEntity {
  final double? latitude;
  final double? longitude;

  const BranchSetupCoordinatesEntity({this.latitude, this.longitude});
}

class BranchSetupGovernorateEntity {
  final int id;
  final String name;

  const BranchSetupGovernorateEntity({required this.id, required this.name});
}

class BranchSetupLocationEntity {
  final BranchSetupGovernorateEntity? governorate;
  final String address;
  final BranchSetupCoordinatesEntity coordinates;

  const BranchSetupLocationEntity({
    this.governorate,
    required this.address,
    required this.coordinates,
  });
}

class BranchSetupWorkingHourEntity {
  final int day;
  final String? openTime;
  final String? closeTime;
  final bool isClosed;

  const BranchSetupWorkingHourEntity({
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.isClosed,
  });
}

class BranchSetupImageEntity {
  final int id;
  final int type;
  final String url;
  final int displayOrder;

  const BranchSetupImageEntity({
    required this.id,
    required this.type,
    required this.url,
    required this.displayOrder,
  });
}

class BranchSetupDetailsEntity {
  final BranchSetupBusinessDetailsEntity businessDetails;
  final BranchSetupLocationEntity location;
  final List<BranchSetupWorkingHourEntity> workingHours;
  final List<BranchSetupImageEntity> images;

  const BranchSetupDetailsEntity({
    required this.businessDetails,
    required this.location,
    required this.workingHours,
    required this.images,
  });
}
