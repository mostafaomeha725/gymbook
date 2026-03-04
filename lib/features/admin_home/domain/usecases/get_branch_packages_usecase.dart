import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/packages_list_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class GetBranchPackagesUseCase {
  final AdminBranchRepository repository;

  GetBranchPackagesUseCase(this.repository);

  Future<Either<Failure, PackagesListEntity>> call({
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
