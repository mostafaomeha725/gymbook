import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/created_branch_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/branch_repository.dart';

class CreateBranchUseCase {
  final BranchRepository repository;

  CreateBranchUseCase(this.repository);

  Future<Either<Failure, CreatedBranchEntity>> call({
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) {
    return repository.createBranch(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      branchType: branchType,
    );
  }
}
