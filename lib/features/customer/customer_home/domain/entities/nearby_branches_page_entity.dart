import 'package:gymbook/features/customer/customer_home/domain/entities/nearby_branch_entity.dart';

class NearbyBranchesPageEntity {
  final List<NearbyBranchEntity> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const NearbyBranchesPageEntity({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
}
