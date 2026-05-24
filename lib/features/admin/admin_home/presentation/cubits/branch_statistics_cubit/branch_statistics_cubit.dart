import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_statistics_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_statistics_usecase.dart';

part 'branch_statistics_state.dart';

class BranchStatisticsCubit extends Cubit<BranchStatisticsState> {
  BranchStatisticsCubit(this.getBranchStatisticsUseCase)
    : super(BranchStatisticsInitial());

  final GetBranchStatisticsUseCase getBranchStatisticsUseCase;

  Future<void> loadStatistics({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  }) async {
    emit(BranchStatisticsLoading());

    final result = await getBranchStatisticsUseCase(
      branchId: branchId,
      timePeriod: timePeriod,
    );

    result.fold(
      (failure) => emit(BranchStatisticsFailure(failure.message)),
      (entity) => emit(BranchStatisticsSuccess(entity)),
    );
  }
}
