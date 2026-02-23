part of 'branch_working_hours_cubit.dart';

sealed class BranchWorkingHoursState {}

final class BranchWorkingHoursInitial extends BranchWorkingHoursState {}

final class BranchWorkingHoursLoading extends BranchWorkingHoursState {}

final class BranchWorkingHoursSuccess extends BranchWorkingHoursState {}

final class BranchWorkingHoursFailure extends BranchWorkingHoursState {
  final String message;

  BranchWorkingHoursFailure(this.message);
}
