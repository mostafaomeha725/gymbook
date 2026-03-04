part of 'create_branch_cubit.dart';

sealed class CreateBranchState {
  const CreateBranchState();
}

final class CreateBranchInitial extends CreateBranchState {}

final class CreateBranchLoading extends CreateBranchState {}

final class CreateBranchSuccess extends CreateBranchState {
  final CreatedBranchEntity branchResponse;

  const CreateBranchSuccess(this.branchResponse);
}

final class CreateBranchFailure extends CreateBranchState {
  final String message;

  CreateBranchFailure(this.message);
}
