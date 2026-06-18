import 'package:flutter/foundation.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsStatusLoading extends NotificationsState {}

class NotificationsStatusLoaded extends NotificationsState {
  final bool isEnabled;
  NotificationsStatusLoaded(this.isEnabled);
}

class NotificationsToggling extends NotificationsState {}

class NotificationsToggled extends NotificationsState {
  final bool isEnabled;
  NotificationsToggled(this.isEnabled);
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}

class NotificationsTokenUpdating extends NotificationsState {}

class NotificationsTokenUpdated extends NotificationsState {}

class NotificationsTokenUpdateError extends NotificationsState {
  final String message;
  NotificationsTokenUpdateError(this.message);
}
