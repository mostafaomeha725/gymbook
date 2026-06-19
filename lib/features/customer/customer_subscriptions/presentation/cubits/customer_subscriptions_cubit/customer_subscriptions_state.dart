import 'package:equatable/equatable.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscription_model.dart';

abstract class CustomerSubscriptionsState extends Equatable {
  const CustomerSubscriptionsState();

  @override
  List<Object> get props => [];
}

class CustomerSubscriptionsInitial extends CustomerSubscriptionsState {}

class CustomerSubscriptionsLoading extends CustomerSubscriptionsState {}

class CustomerSubscriptionsLoaded extends CustomerSubscriptionsState {
  final List<CustomerSubscriptionModel> subscriptions;

  const CustomerSubscriptionsLoaded(this.subscriptions);

  @override
  List<Object> get props => [subscriptions];
}

class CustomerSubscriptionsError extends CustomerSubscriptionsState {
  final String message;

  const CustomerSubscriptionsError(this.message);

  @override
  List<Object> get props => [message];
}
