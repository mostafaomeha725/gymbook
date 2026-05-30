import 'package:gymbook/features/admin/admin_home/domain/entities/branch_reviews_entity.dart';
import 'package:gymbook/features/admin/admin_home/data/models/review_model.dart';

class BranchReviewsModel extends BranchReviewsEntity {
  const BranchReviewsModel({
    required super.data,
    required super.currentPage,
    required super.totalPages,
    required super.totalCount,
    required super.pageSize,
  });

  factory BranchReviewsModel.fromJson(Map<String, dynamic> json) {
    return BranchReviewsModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalCount: json['totalCount'] ?? 0,
      pageSize: json['pageSize'] ?? 10,
    );
  }
}
