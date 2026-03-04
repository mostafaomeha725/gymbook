import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class DeletePackageUseCase {
  final AdminBranchRepository repository;

  DeletePackageUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int branchId,
    required int packageId,
  }) {
    return repository.deletePackage(branchId: branchId, packageId: packageId);
  }
}
