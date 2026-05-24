class ReviewEntity {
  final String id;
  final String authorName;
  final String content;
  final double rating;
  final String timeAgo;
  final String? initials;

  const ReviewEntity({
    required this.id,
    required this.authorName,
    required this.content,
    required this.rating,
    required this.timeAgo,
    this.initials,
  });
}
