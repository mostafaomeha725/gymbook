import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/branch_repository.dart';

class EditBranchUseCase {
  final BranchRepository repository;

  EditBranchUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int branchId,
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) {
    return repository.editBranch(
      branchId: branchId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      branchType: branchType,
    );
  }
}
