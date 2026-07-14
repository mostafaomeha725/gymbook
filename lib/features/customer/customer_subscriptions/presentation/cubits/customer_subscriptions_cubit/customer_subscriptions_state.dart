import 'package:equatable/equatable.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscriptions_page_model.dart';

abstract class CustomerSubscriptionsState extends Equatable {
  const CustomerSubscriptionsState();

  @override
  List<Object> get props => [];
}

class CustomerSubscriptionsInitial extends CustomerSubscriptionsState {}

class CustomerSubscriptionsLoading extends CustomerSubscriptionsState {}

class CustomerSubscriptionsLoaded extends CustomerSubscriptionsState {
  final CustomerSubscriptionsPageModel pageModel;

  const CustomerSubscriptionsLoaded(this.pageModel);

  @override
  List<Object> get props => [pageModel];
}

class CustomerSubscriptionsError extends CustomerSubscriptionsState {
  final String message;

  const CustomerSubscriptionsError(this.message);

  @override
  List<Object> get props => [message];
}
