import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class UpdatePackageStatusUseCase {
  final AdminBranchRepository repository;

  UpdatePackageStatusUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int branchId,
    required int packageId,
    required bool isActive,
  }) {
    return repository.updatePackageStatus(
      branchId: branchId,
      packageId: packageId,
      isActive: isActive,
    );
  }
}
