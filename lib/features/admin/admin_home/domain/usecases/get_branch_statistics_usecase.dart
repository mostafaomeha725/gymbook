import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_statistics_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/branch_repository.dart';

class GetBranchStatisticsUseCase {
  final BranchRepository repository;

  GetBranchStatisticsUseCase(this.repository);

  Stream<Either<Failure, BranchStatisticsEntity>> call({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  }) {
    if (branchId == 0) {
      return repository.getAllBranchesStatistics(timePeriod: timePeriod);
    }
    return repository.getBranchStatistics(
      branchId: branchId,
      timePeriod: timePeriod,
    );
  }
}
