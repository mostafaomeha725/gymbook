abstract class CancelSubscriptionState {}

class CancelSubscriptionInitial extends CancelSubscriptionState {}

class CancelSubscriptionLoading extends CancelSubscriptionState {}

class CancelSubscriptionSuccess extends CancelSubscriptionState {}

class CancelSubscriptionFailure extends CancelSubscriptionState {
  final String message;
  CancelSubscriptionFailure(this.message);
}
