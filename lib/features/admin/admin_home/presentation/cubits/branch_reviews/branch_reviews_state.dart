part of 'branch_reviews_cubit.dart';

abstract class BranchReviewsState {}

class BranchReviewsInitial extends BranchReviewsState {}

class BranchReviewsLoading extends BranchReviewsState {}

class BranchReviewsLoaded extends BranchReviewsState {
  final List<ReviewEntity> reviews;
  final String selectedRating;
  final int currentPage;
  final int totalPages;
  final double averageRating;
  final int totalCount;
  final bool canReview;
  final ReviewEntity? myReview;

  final bool isFetchingMore;
  final bool hasReachedMax;

  BranchReviewsLoaded({
    required this.reviews,
    required this.selectedRating,
    required this.currentPage,
    required this.totalPages,
    required this.averageRating,
    required this.totalCount,
    required this.canReview,
    this.myReview,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
  });

  BranchReviewsLoaded copyWith({
    List<ReviewEntity>? reviews,
    String? selectedRating,
    int? currentPage,
    int? totalPages,
    double? averageRating,
    int? totalCount,
    bool? canReview,
    ReviewEntity? myReview,
    bool? isFetchingMore,
    bool? hasReachedMax,
  }) {
    return BranchReviewsLoaded(
      reviews: reviews ?? this.reviews,
      selectedRating: selectedRating ?? this.selectedRating,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      averageRating: averageRating ?? this.averageRating,
      totalCount: totalCount ?? this.totalCount,
      canReview: canReview ?? this.canReview,
      myReview: myReview ?? this.myReview,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class BranchReviewsError extends BranchReviewsState {
  final String message;
  BranchReviewsError(this.message);
}
