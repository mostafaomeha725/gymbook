import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/branch_repository.dart';

class GetBranchDetailsUseCase {
  final BranchRepository repository;

  GetBranchDetailsUseCase(this.repository);

  Stream<Either<Failure, BranchDetailsEntity>> call(int branchId) {
    return repository.getBranchDetails(branchId);
  }
}
