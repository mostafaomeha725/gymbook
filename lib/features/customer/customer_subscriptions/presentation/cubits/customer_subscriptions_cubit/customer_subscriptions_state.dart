import 'package:equatable/equatable.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscriptions_page_model.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscription_model.dart';

abstract class CustomerSubscriptionsState extends Equatable {
  const CustomerSubscriptionsState();

  @override
  List<Object> get props => [];
}

class CustomerSubscriptionsInitial extends CustomerSubscriptionsState {}

class CustomerSubscriptionsLoading extends CustomerSubscriptionsState {}

class CustomerSubscriptionsLoaded extends CustomerSubscriptionsState {
  final CustomerSubscriptionsPageModel pageModel;
  final List<CustomerSubscriptionModel> items;
  final bool isFetchingMore;
  final bool hasReachedMax;

  const CustomerSubscriptionsLoaded({
    required this.pageModel,
    required this.items,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
  });

  CustomerSubscriptionsLoaded copyWith({
    CustomerSubscriptionsPageModel? pageModel,
    List<CustomerSubscriptionModel>? items,
    bool? isFetchingMore,
    bool? hasReachedMax,
  }) {
    return CustomerSubscriptionsLoaded(
      pageModel: pageModel ?? this.pageModel,
      items: items ?? this.items,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [pageModel, items, isFetchingMore, hasReachedMax];
}

class CustomerSubscriptionsError extends CustomerSubscriptionsState {
  final String message;

  const CustomerSubscriptionsError(this.message);

  @override
  List<Object> get props => [message];
}
