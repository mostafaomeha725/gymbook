part of 'admin_my_branches_cubit.dart';

sealed class AdminMyBranchesState {}

final class AdminMyBranchesInitial extends AdminMyBranchesState {}

final class AdminMyBranchesLoading extends AdminMyBranchesState {}

final class AdminMyBranchesSuccess extends AdminMyBranchesState {
  final List<AdminBranchOptionEntity> branches;

  AdminMyBranchesSuccess(this.branches);
}

final class AdminMyBranchesFailure extends AdminMyBranchesState {
  final String message;

  AdminMyBranchesFailure(this.message);
}
