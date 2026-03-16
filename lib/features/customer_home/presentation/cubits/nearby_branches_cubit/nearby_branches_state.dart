part of 'nearby_branches_cubit.dart';

sealed class NearbyBranchesState {}

final class NearbyBranchesInitial extends NearbyBranchesState {}

final class NearbyBranchesLoading extends NearbyBranchesState {}

final class NearbyBranchesSuccess extends NearbyBranchesState {
  final NearbyBranchesPageEntity response;
  NearbyBranchesSuccess(this.response);
}

final class NearbyBranchesFailure extends NearbyBranchesState {
  final String message;
  NearbyBranchesFailure(this.message);
}
