import 'package:flutter/foundation.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsTokenUpdating extends NotificationsState {}

class NotificationsTokenUpdated extends NotificationsState {}

class NotificationsTokenUpdateError extends NotificationsState {
  final String message;
  NotificationsTokenUpdateError(this.message);
}
