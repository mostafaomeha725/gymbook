part of 'branches_list_cubit.dart';

sealed class BranchesListState {}

final class BranchesListInitial extends BranchesListState {}

final class BranchesListLoading extends BranchesListState {}

final class BranchesListSuccess extends BranchesListState {
  final BranchListEntity response;
  BranchesListSuccess(this.response);
}

final class BranchesListFailure extends BranchesListState {
  final String message;
  BranchesListFailure(this.message);
}
