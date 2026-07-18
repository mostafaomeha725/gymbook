part of 'branch_subscriptions_list_cubit.dart';

sealed class BranchSubscriptionsListState {}

final class BranchSubscriptionsListInitial
    extends BranchSubscriptionsListState {}

final class BranchSubscriptionsListLoading
    extends BranchSubscriptionsListState {}

final class BranchSubscriptionsListSuccess
    extends BranchSubscriptionsListState {
  final SubscriptionsListEntity response;
  final List<SubscriptionItemEntity> items;
  final bool isFetchingMore;
  final bool hasReachedMax;

  BranchSubscriptionsListSuccess({
    required this.response,
    required this.items,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
  });

  BranchSubscriptionsListSuccess copyWith({
    SubscriptionsListEntity? response,
    List<SubscriptionItemEntity>? items,
    bool? isFetchingMore,
    bool? hasReachedMax,
  }) {
    return BranchSubscriptionsListSuccess(
      response: response ?? this.response,
      items: items ?? this.items,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

final class BranchSubscriptionsListFailure
    extends BranchSubscriptionsListState {
  final String message;
  BranchSubscriptionsListFailure(this.message);
}
