import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_setup_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_setup_details_usecase.dart';

part 'branch_setup_state.dart';

class BranchSetupCubit extends Cubit<BranchSetupState> {
  BranchSetupCubit(this.getBranchSetupDetailsUseCase)
    : super(const BranchSetupState());

  final GetBranchSetupDetailsUseCase getBranchSetupDetailsUseCase;

  static const Map<int, String> weekdaysByIndex = {
    0: 'Sunday',
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
  };

  void setEditModeData({required bool isEdit}) {
    emit(
      state.copyWith(
        isEditMode: isEdit,
        clearError: true,
        clearDetails: !isEdit,
      ),
    );
  }

  StreamSubscription? _subscription;

  Future<void> fetchBranchDetails(int branchId) async {
    if (!state.isEditMode || branchId <= 0) return;

    debugPrint(
      '[BranchSetupCubit] fetchBranchDetails start | branchId=$branchId | isEditMode=${state.isEditMode}',
    );

    _subscription?.cancel();

    if (state.details == null) {
      emit(state.copyWith(isLoading: true, clearError: true));
    }

    _subscription = getBranchSetupDetailsUseCase(branchId).listen((result) {
      result.fold(
        (failure) {
          debugPrint(
            '[BranchSetupCubit] fetchBranchDetails failure | branchId=$branchId | message=${failure.message}',
          );
          if (state.details == null) {
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: failure.message,
                clearDetails: true,
              ),
            );
          }
        },
        (details) {
          debugPrint(
            '[BranchSetupCubit] fetchBranchDetails success | branchId=$branchId',
          );
          emit(
            state.copyWith(
              isLoading: false,
              details: details,
              clearError: true,
            ),
          );
        },
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  String dayNameFromIndex(int day) {
    return weekdaysByIndex[day] ?? 'Unknown';
  }

  TimeOfDay? parseApiTime(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final parts = value.split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String formatTimeToApi(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }
}
