import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/packages_list_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/package_repository.dart';

class GetBranchPackagesUseCase {
  final PackageRepository repository;

  GetBranchPackagesUseCase(this.repository);

  Stream<Either<Failure, PackagesListEntity>> call({
    required int branchId,
    required int pageNumber,
    required int pageSize,
  }) {
    return repository.getBranchPackages(
      branchId: branchId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
