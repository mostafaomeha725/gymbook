import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_statistics_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_statistics_usecase.dart';

part 'branch_statistics_state.dart';

class BranchStatisticsCubit extends Cubit<BranchStatisticsState> {
  BranchStatisticsCubit(this.getBranchStatisticsUseCase)
    : super(BranchStatisticsInitial());

  final GetBranchStatisticsUseCase getBranchStatisticsUseCase;
  StreamSubscription? _subscription;
  StatisticsTimePeriod? _currentTimePeriod;

  Future<void> loadStatistics({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  }) async {
    _subscription?.cancel();

    bool periodChanged = _currentTimePeriod != timePeriod;
    _currentTimePeriod = timePeriod;

    if (state is! BranchStatisticsSuccess || periodChanged) {
      emit(BranchStatisticsLoading());
    }

    _subscription =
        getBranchStatisticsUseCase(
          branchId: branchId,
          timePeriod: timePeriod,
        ).listen((result) {
          result.fold((failure) {
            if (state is! BranchStatisticsSuccess) {
              emit(BranchStatisticsFailure(failure.message));
            }
          }, (entity) => emit(BranchStatisticsSuccess(entity)));
        });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
