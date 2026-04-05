import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/repositories/branch_repository.dart';

class ActivateBranchImagesUseCase {
  final BranchRepository repository;

  ActivateBranchImagesUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int branchId,
    required List<int> imageIds,
  }) {
    return repository.activateBranchImages(
      branchId: branchId,
      imageIds: imageIds,
    );
  }
}
