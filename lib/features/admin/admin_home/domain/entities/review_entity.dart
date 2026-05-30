class ReviewEntity {
  final int id;
  final String authorName;
  final String content;
  final double rating;
  final String timeAgo;
  final String? initials;
  final DateTime reviewedAt;

  const ReviewEntity({
    required this.id,
    required this.authorName,
    required this.content,
    required this.rating,
    required this.timeAgo,
    this.initials,
    required this.reviewedAt,
  });
}
