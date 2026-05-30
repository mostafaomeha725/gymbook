abstract class AddReviewState {}

class AddReviewInitial extends AddReviewState {}

class AddReviewLoading extends AddReviewState {}

class AddReviewSuccess extends AddReviewState {
  final int reviewId;

  AddReviewSuccess({required this.reviewId});
}

class AddReviewUpdated extends AddReviewState {}

class AddReviewError extends AddReviewState {
  final String message;

  AddReviewError(this.message);
}
