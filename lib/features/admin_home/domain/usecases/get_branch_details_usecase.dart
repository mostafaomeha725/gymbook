import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_details_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class GetBranchDetailsUseCase {
  final AdminBranchRepository repository;

  GetBranchDetailsUseCase(this.repository);

  Future<Either<Failure, BranchDetailsEntity>> call(int branchId) {
    return repository.getBranchDetails(branchId);
  }
}
