import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_reviews_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/branch_repository.dart';

class GetBranchReviewsUseCase {
  final BranchRepository repository;

  GetBranchReviewsUseCase(this.repository);

  Future<Either<Failure, BranchReviewsEntity>> call({
    required int branchId,
    int pageNumber = 1,
    int pageSize = 5,
    double? rating,
  }) {
    return repository.getBranchReviews(
      branchId: branchId,
      pageNumber: pageNumber,
      pageSize: pageSize,
      rating: rating,
    );
  }
}
