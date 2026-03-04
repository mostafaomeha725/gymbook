import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class UpdateWorkingHoursUseCase {
  final AdminBranchRepository repository;

  UpdateWorkingHoursUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int branchId,
    required List<Map<String, dynamic>> workingHours,
  }) {
    return repository.updateBranchWorkingHours(
      branchId: branchId,
      workingHours: workingHours,
    );
  }
}
