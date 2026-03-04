import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_working_hours_usecase.dart';

part 'branch_working_hours_state.dart';

class BranchWorkingHoursCubit extends Cubit<BranchWorkingHoursState> {
  BranchWorkingHoursCubit(this.updateWorkingHoursUseCase)
    : super(BranchWorkingHoursInitial());

  final UpdateWorkingHoursUseCase updateWorkingHoursUseCase;

  Future<bool> submitBranchWorkingHours({
    required int branchId,
    required Map<String, dynamic>? branchHours,
  }) async {
    if (branchId <= 0) {
      const message = 'Invalid branch ID';
      showError(message);
      emit(BranchWorkingHoursFailure(message));
      return false;
    }

    final workingHours = _extractWorkingHours(branchHours);
    if (workingHours.isEmpty) {
      const message = 'Working hours list cannot be empty';
      showError(message);
      emit(BranchWorkingHoursFailure(message));
      return false;
    }

    final hasInvalidOpenDay = workingHours.any((day) {
      final isClosed = day['isClosed'] as bool? ?? true;
      if (isClosed) return false;
      final openTime = day['openTime']?.toString() ?? '';
      final closeTime = day['closeTime']?.toString() ?? '';
      return openTime.isEmpty || closeTime.isEmpty;
    });

    if (hasInvalidOpenDay) {
      const message = 'Please set valid working hours for all open days';
      showError(message);
      emit(BranchWorkingHoursFailure(message));
      return false;
    }

    emit(BranchWorkingHoursLoading());
    showLoading();

    final result = await updateWorkingHoursUseCase(
      branchId: branchId,
      workingHours: workingHours,
    );

    hideLoading();

    return result.fold(
      (failure) {
        showError(failure.message);
        emit(BranchWorkingHoursFailure(failure.message));
        return false;
      },
      (_) {
        showSuccess('Working hours updated successfully');
        emit(BranchWorkingHoursSuccess());
        return true;
      },
    );
  }

  List<Map<String, dynamic>> _extractWorkingHours(
    Map<String, dynamic>? source,
  ) {
    final raw = source?['workingHours'];
    if (raw is! List) return [];

    return raw
        .whereType<Map>()
        .map((day) => Map<String, dynamic>.from(day))
        .toList();
  }
}
