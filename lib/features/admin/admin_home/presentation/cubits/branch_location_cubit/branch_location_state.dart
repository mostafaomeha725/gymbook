part of 'branch_location_cubit.dart';

sealed class BranchLocationState {}

final class BranchLocationInitial extends BranchLocationState {}

final class BranchLocationLoading extends BranchLocationState {}

final class BranchLocationSuccess extends BranchLocationState {}

final class BranchLocationFailure extends BranchLocationState {
  final String message;

  BranchLocationFailure(this.message);
}
