import 'package:gymbook/features/admin/admin_home/domain/entities/subscription_details_entity.dart';

abstract class SubscriptionDetailsState {}

class SubscriptionDetailsInitial extends SubscriptionDetailsState {}

class SubscriptionDetailsLoading extends SubscriptionDetailsState {}

class SubscriptionDetailsSuccess extends SubscriptionDetailsState {
  final SubscriptionDetailsEntity details;
  SubscriptionDetailsSuccess(this.details);
}

class SubscriptionDetailsFailure extends SubscriptionDetailsState {
  final String message;
  SubscriptionDetailsFailure(this.message);
}
