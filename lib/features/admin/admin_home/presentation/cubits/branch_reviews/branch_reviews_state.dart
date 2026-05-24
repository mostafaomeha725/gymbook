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

  BranchReviewsLoaded({
    required this.reviews,
    required this.selectedRating,
    required this.currentPage,
    required this.totalPages,
    required this.averageRating,
    required this.totalCount,
  });
}

class BranchReviewsError extends BranchReviewsState {
  final String message;
  BranchReviewsError(this.message);
}
