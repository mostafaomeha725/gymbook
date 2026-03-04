part of 'branch_packages_list_cubit.dart';

sealed class BranchPackagesListState {}

final class BranchPackagesListInitial extends BranchPackagesListState {}

final class BranchPackagesListLoading extends BranchPackagesListState {}

final class BranchPackagesListSuccess extends BranchPackagesListState {
  final PackagesListEntity response;

  BranchPackagesListSuccess(this.response);
}

final class BranchPackagesListFailure extends BranchPackagesListState {
  final String message;

  BranchPackagesListFailure(this.message);
}
