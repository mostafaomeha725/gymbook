import 'package:gymbook/features/admin/admin_home/domain/entities/branch_reviews_entity.dart';
import 'package:gymbook/features/admin/admin_home/data/models/review_model.dart';

class BranchReviewsModel extends BranchReviewsEntity {
  const BranchReviewsModel({
    required super.data,
    required super.currentPage,
    required super.totalPages,
    required super.totalCount,
    required super.pageSize,
    required super.canReview,
    super.myReview,
  });

  factory BranchReviewsModel.fromJson(Map<String, dynamic> json) {
    return BranchReviewsModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalCount: json['totalCount'] ?? 0,
      pageSize: json['pageSize'] ?? 10,
      canReview: json['meta']?['canReview'] ?? false,
      myReview: json['meta']?['myReview'] != null
          ? ReviewModel.fromJson(json['meta']['myReview'])
          : null,
    );
  }
}
