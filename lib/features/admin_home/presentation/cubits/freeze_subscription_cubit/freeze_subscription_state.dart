abstract class FreezeSubscriptionState {}

class FreezeSubscriptionInitial extends FreezeSubscriptionState {}

class FreezeSubscriptionLoading extends FreezeSubscriptionState {}

class FreezeSubscriptionSuccess extends FreezeSubscriptionState {}

class FreezeSubscriptionFailure extends FreezeSubscriptionState {
  final String message;
  FreezeSubscriptionFailure(this.message);
}
