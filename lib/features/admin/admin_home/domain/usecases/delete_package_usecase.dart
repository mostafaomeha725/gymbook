import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/package_repository.dart';

class DeletePackageUseCase {
  final PackageRepository repository;

  DeletePackageUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int branchId,
    required int packageId,
  }) {
    return repository.deletePackage(branchId: branchId, packageId: packageId);
  }
}
