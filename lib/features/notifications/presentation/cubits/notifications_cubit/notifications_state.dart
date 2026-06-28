import 'package:equatable/equatable.dart';
import 'package:gymbook/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final int badgeCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.badgeCount,
  });

  @override
  List<Object?> get props => [notifications, badgeCount];
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationsTokenUpdating extends NotificationsState {}
class NotificationsTokenUpdated extends NotificationsState {}
class NotificationsTokenUpdateError extends NotificationsState {
  final String message;
  const NotificationsTokenUpdateError(this.message);
  @override
  List<Object?> get props => [message];
}

class NotificationsStatusLoading extends NotificationsState {}
class NotificationsStatusLoaded extends NotificationsState {
  final bool isEnabled;
  const NotificationsStatusLoaded(this.isEnabled);
  @override
  List<Object?> get props => [isEnabled];
}
class NotificationsToggling extends NotificationsState {}
class NotificationsToggled extends NotificationsState {
  final bool isEnabled;
  const NotificationsToggled(this.isEnabled);
  @override
  List<Object?> get props => [isEnabled];
}
