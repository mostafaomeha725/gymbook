import 'package:gymbook/core/enums/app_enums.dart';

class NearbyBranchEntity {
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

  const NearbyBranchEntity({
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

  GymType get gymType => branchType == 0
      ? GymType.menOnly
      : branchType == 1
      ? GymType.womenOnly
      : GymType.mixed;

  String get branchTypeName => gymType == GymType.menOnly
      ? 'Male Only'
      : gymType == GymType.womenOnly
      ? 'Female Only'
      : 'Mixed';
}
