import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class UpdateBranchStatusUseCase {
  final AdminBranchRepository repository;

  UpdateBranchStatusUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int branchId,
    required int branchStatus,
  }) {
    return repository.updateBranchStatus(
      branchId: branchId,
      branchStatus: branchStatus,
    );
  }
}
