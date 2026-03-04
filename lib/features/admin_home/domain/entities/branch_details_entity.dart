import 'package:gymbook/features/admin_home/domain/entities/governorate_entity.dart';

class BranchDetailsEntity {
  final int id;
  final String name;
  final int branchType;
  final int branchStatus;
  final List<dynamic> images;
  final GovernorateEntity? governorate;
  final String address;
  final bool isOpenNow;
  final int activePackagesCount;
  final int activeSubscriptionsCount;

  const BranchDetailsEntity({
    required this.id,
    required this.name,
    required this.branchType,
    required this.branchStatus,
    required this.images,
    this.governorate,
    required this.address,
    required this.isOpenNow,
    required this.activePackagesCount,
    required this.activeSubscriptionsCount,
  });
}
