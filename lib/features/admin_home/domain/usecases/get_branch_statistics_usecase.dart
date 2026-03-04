import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_statistics_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class GetBranchStatisticsUseCase {
  final AdminBranchRepository repository;

  GetBranchStatisticsUseCase(this.repository);

  Future<Either<Failure, BranchStatisticsEntity>> call({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  }) {
    return repository.getBranchStatistics(
      branchId: branchId,
      timePeriod: timePeriod,
    );
  }
}
