import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/repositories/add_review_repository.dart';

class AddReviewUseCase {
  final AddReviewRepository repository;

  AddReviewUseCase(this.repository);

  Future<Either<Failure, int>> call(AddReviewParams params) async {
    return await repository.addReview(
      branchId: params.branchId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class UpdateReviewUseCase {
  final AddReviewRepository repository;

  UpdateReviewUseCase(this.repository);

  Future<Either<Failure, void>> call(UpdateReviewParams params) async {
    return await repository.updateReview(
      branchId: params.branchId,
      reviewId: params.reviewId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class AddReviewParams {
  final int branchId;
  final int rating;
  final String comment;

  AddReviewParams({
    required this.branchId,
    required this.rating,
    required this.comment,
  });
}

class UpdateReviewParams {
  final int branchId;
  final int reviewId;
  final int rating;
  final String comment;

  UpdateReviewParams({
    required this.branchId,
    required this.reviewId,
    required this.rating,
    required this.comment,
  });
}
