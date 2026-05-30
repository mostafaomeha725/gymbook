import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';

abstract class AddReviewRepository {
  Future<Either<Failure, int>> addReview({
    required int branchId,
    required int rating,
    required String comment,
  });

  Future<Either<Failure, void>> updateReview({
    required int branchId,
    required int reviewId,
    required int rating,
    required String comment,
  });
}
