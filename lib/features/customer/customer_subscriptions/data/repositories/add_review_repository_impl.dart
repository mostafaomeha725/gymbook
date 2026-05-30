import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/datasources/add_review_remote_datasource.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/repositories/add_review_repository.dart';

class AddReviewRepositoryImpl implements AddReviewRepository {
  final AddReviewRemoteDataSource remoteDataSource;

  AddReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, int>> addReview({
    required int branchId,
    required int rating,
    required String comment,
  }) async {
    try {
      final reviewId = await remoteDataSource.addReview(
        branchId: branchId,
        rating: rating,
        comment: comment,
      );
      return Right(reviewId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateReview({
    required int branchId,
    required int reviewId,
    required int rating,
    required String comment,
  }) async {
    try {
      await remoteDataSource.updateReview(
        branchId: branchId,
        reviewId: reviewId,
        rating: rating,
        comment: comment,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
