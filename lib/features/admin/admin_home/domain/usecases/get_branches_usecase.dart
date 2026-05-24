import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_list_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/branch_repository.dart';

class GetBranchesUseCase {
  final BranchRepository repository;

  GetBranchesUseCase(this.repository);

  Future<Either<Failure, BranchListEntity>> call({
    int pageNumber = 1,
    int pageSize = 10,
    String? search,
  }) {
    return repository.getBranches(
      pageNumber: pageNumber,
      pageSize: pageSize,
      search: search,
    );
  }
}
