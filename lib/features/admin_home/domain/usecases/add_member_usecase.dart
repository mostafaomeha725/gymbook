import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/add_member_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class AddMemberUseCase {
  final AdminBranchRepository repository;
  AddMemberUseCase(this.repository);

  Future<Either<Failure, AddMemberEntity>> call({
    required int branchId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required int packageId,
  }) {
    return repository.addMember(
      branchId: branchId,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      email: email,
      packageId: packageId,
    );
  }
}
