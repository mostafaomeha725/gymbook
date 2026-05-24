part of 'add_subscription_cubit.dart';

abstract class AddSubscriptionState {}

class AddSubscriptionInitial extends AddSubscriptionState {}

class AddSubscriptionLoading extends AddSubscriptionState {}

class AddSubscriptionSuccess extends AddSubscriptionState {
  final AddSubscriptionEntity result;
  AddSubscriptionSuccess(this.result);
}

class AddSubscriptionFailure extends AddSubscriptionState {
  final String message;
  AddSubscriptionFailure(this.message);
}
