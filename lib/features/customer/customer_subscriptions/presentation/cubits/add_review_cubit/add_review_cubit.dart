import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/usecases/add_review_usecase.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/add_review_cubit/add_review_state.dart';

class AddReviewCubit extends Cubit<AddReviewState> {
  final AddReviewUseCase addReviewUseCase;
  final UpdateReviewUseCase updateReviewUseCase;

  int? _reviewId;

  AddReviewCubit({
    required this.addReviewUseCase,
    required this.updateReviewUseCase,
  }) : super(AddReviewInitial());

  bool get hasReview => _reviewId != null;

  Future<void> submitReview({
    required int branchId,
    required int rating,
    required String comment,
  }) async {
    emit(AddReviewLoading());

    if (_reviewId != null) {
      final result = await updateReviewUseCase(
        UpdateReviewParams(
          branchId: branchId,
          reviewId: _reviewId!,
          rating: rating,
          comment: comment,
        ),
      );
      result.fold(
        (failure) => emit(AddReviewError(failure.message)),
        (_) => emit(AddReviewUpdated()),
      );
    } else {
      final result = await addReviewUseCase(
        AddReviewParams(branchId: branchId, rating: rating, comment: comment),
      );
      result.fold((failure) => emit(AddReviewError(failure.message)), (
        reviewId,
      ) {
        _reviewId = reviewId;
        emit(AddReviewSuccess(reviewId: reviewId));
      });
    }
  }
}
