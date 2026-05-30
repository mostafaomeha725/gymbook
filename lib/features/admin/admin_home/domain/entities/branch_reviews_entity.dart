import 'package:gymbook/features/admin/admin_home/domain/entities/review_entity.dart';

class BranchReviewsEntity {
  final List<ReviewEntity> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;

  const BranchReviewsEntity({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
  });
}
