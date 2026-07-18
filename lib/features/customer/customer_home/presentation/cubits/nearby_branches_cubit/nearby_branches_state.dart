part of 'nearby_branches_cubit.dart';

sealed class NearbyBranchesState {}

final class NearbyBranchesInitial extends NearbyBranchesState {}

final class NearbyBranchesLoading extends NearbyBranchesState {}

final class NearbyBranchesSuccess extends NearbyBranchesState {
  final NearbyBranchesPageEntity response;
  final List<NearbyBranchEntity> branches;
  final bool isFetchingMore;
  final bool hasReachedMax;

  NearbyBranchesSuccess({
    required this.response,
    required this.branches,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
  });

  NearbyBranchesSuccess copyWith({
    NearbyBranchesPageEntity? response,
    List<NearbyBranchEntity>? branches,
    bool? isFetchingMore,
    bool? hasReachedMax,
  }) {
    return NearbyBranchesSuccess(
      response: response ?? this.response,
      branches: branches ?? this.branches,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

final class NearbyBranchesFailure extends NearbyBranchesState {
  final String message;
  NearbyBranchesFailure(this.message);
}
