import 'package:gymbook/features/admin/admin_home/domain/entities/review_entity.dart';
import 'package:gymbook/core/utils/app_date_time.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required super.id,
    required super.authorName,
    required super.content,
    required super.rating,
    required super.timeAgo,
    super.initials,
    required super.reviewedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final reviewedAt =
        DateTime.tryParse(json['reviewedAt'] ?? '') ?? DateTime.now();
    final fullName = json['userFullName'] as String? ?? 'Unknown';

    String initials = '';
    if (fullName.isNotEmpty) {
      final parts = fullName.split(' ');
      if (parts.length > 1) {
        initials = parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
      } else {
        initials = fullName[0].toUpperCase();
      }
    }

    return ReviewModel(
      id: json['id'] ?? 0,
      authorName: fullName,
      content: json['comment'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      timeAgo: AppDateTime.utcToLocalTime(reviewedAt.toIso8601String()),
      initials: initials,
      reviewedAt: reviewedAt,
    );
  }
}
