import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class UpdateBranchLocationUseCase {
  final AdminBranchRepository repository;

  UpdateBranchLocationUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int branchId,
    required int governorateId,
    required String address,
    required double latitude,
    required double longitude,
  }) {
    return repository.updateBranchLocationDetails(
      branchId: branchId,
      governorateId: governorateId,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
