import 'package:gymbook/features/admin/admin_home/domain/entities/branch_entity.dart';

class BranchListEntity {
  final List<BranchEntity> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const BranchListEntity({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
}
