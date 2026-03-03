part of 'branch_details_cubit.dart';

sealed class BranchDetailsState {}

final class BranchDetailsInitial extends BranchDetailsState {}

final class BranchDetailsLoading extends BranchDetailsState {}

final class BranchDetailsSuccess extends BranchDetailsState {
  final BranchDetailsResponse response;
  BranchDetailsSuccess(this.response);
}

final class BranchDetailsFailure extends BranchDetailsState {
  final String message;
  BranchDetailsFailure(this.message);
}
