import 'package:bloc/bloc.dart';
import 'package:gymbook/features/customer_subscriptions/domain/usecases/build_attendance_weeks_usecase.dart';
import 'package:gymbook/features/customer_subscriptions/domain/usecases/get_subscription_attendance_history_usecase.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/cubits/subscription_attendance_history_cubit/subscription_attendance_history_state.dart';

class SubscriptionAttendanceHistoryCubit
    extends Cubit<SubscriptionAttendanceHistoryState> {
  SubscriptionAttendanceHistoryCubit(
    this._useCase,
    this._buildAttendanceWeeksUseCase,
  ) : super(SubscriptionAttendanceHistoryInitial());

  final GetSubscriptionAttendanceHistoryUseCase _useCase;
  final BuildAttendanceWeeksUseCase _buildAttendanceWeeksUseCase;

  Future<void> loadAttendanceHistory({
    required int subscriptionId,
    int? year,
    int? month,
  }) async {
    emit(SubscriptionAttendanceHistoryLoading());

    final result = await _useCase(
      subscriptionId: subscriptionId,
      year: year,
      month: month,
    );
    result.fold(
      (failure) => emit(SubscriptionAttendanceHistoryFailure(failure.message)),
      (history) => emit(
        SubscriptionAttendanceHistorySuccess(
          history: history,
          weeks: _buildAttendanceWeeksUseCase(history),
        ),
      ),
    );
  }
}
