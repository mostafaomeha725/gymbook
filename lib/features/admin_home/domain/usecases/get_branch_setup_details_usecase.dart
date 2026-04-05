import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_setup_details_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/branch_repository.dart';

class GetBranchSetupDetailsUseCase {
  final BranchRepository repository;

  GetBranchSetupDetailsUseCase(this.repository);

  Future<Either<Failure, BranchSetupDetailsEntity>> call(int branchId) {
    return repository.getBranchSetupDetails(branchId);
  }
}
