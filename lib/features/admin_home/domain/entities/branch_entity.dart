import 'package:gymbook/features/admin_home/domain/entities/governorate_entity.dart';

class BranchEntity {
  final int id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final GovernorateEntity? governorate;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int branchType;
  final int branchStatus;
  final int? logoImageId;
  final String? logo;
  final int subscriptionsCount;

  const BranchEntity({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.governorate,
    this.address,
    this.latitude,
    this.longitude,
    required this.branchType,
    required this.branchStatus,
    this.logoImageId,
    this.logo,
    required this.subscriptionsCount,
  });

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
