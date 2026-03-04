part of 'branch_subscriptions_list_cubit.dart';

sealed class BranchSubscriptionsListState {}

final class BranchSubscriptionsListInitial
    extends BranchSubscriptionsListState {}

final class BranchSubscriptionsListLoading
    extends BranchSubscriptionsListState {}

final class BranchSubscriptionsListSuccess
    extends BranchSubscriptionsListState {
  final SubscriptionsListEntity response;
  BranchSubscriptionsListSuccess(this.response);
}

final class BranchSubscriptionsListFailure
    extends BranchSubscriptionsListState {
  final String message;
  BranchSubscriptionsListFailure(this.message);
}
