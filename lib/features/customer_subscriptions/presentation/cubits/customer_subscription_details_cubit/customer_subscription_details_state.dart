import 'package:gymbook/features/customer_subscriptions/domain/entities/customer_subscription_details_entity.dart';

abstract class CustomerSubscriptionDetailsState {}

class CustomerSubscriptionDetailsInitial
    extends CustomerSubscriptionDetailsState {}

class CustomerSubscriptionDetailsLoading
    extends CustomerSubscriptionDetailsState {}

class CustomerSubscriptionDetailsSuccess
    extends CustomerSubscriptionDetailsState {
  final CustomerSubscriptionDetailsEntity details;

  CustomerSubscriptionDetailsSuccess(this.details);
}

class CustomerSubscriptionDetailsFailure
    extends CustomerSubscriptionDetailsState {
  final String message;

  CustomerSubscriptionDetailsFailure(this.message);
}
