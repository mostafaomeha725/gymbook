import 'package:gymbook/features/admin_home/domain/entities/governorate_entity.dart';

class BranchImageEntity {
  final int id;
  final int type; // 0 = Logo, 1 = MarketPlace
  final String url;

  const BranchImageEntity({
    required this.id,
    required this.type,
    required this.url,
  });
}

class BranchDetailsEntity {
  final int id;
  final String name;
  final int branchType;
  final int branchStatus;
  final List<BranchImageEntity> images;
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
