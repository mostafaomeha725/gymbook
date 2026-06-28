import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/notifications/domain/entities/notification_entity.dart';
import 'package:gymbook/features/notifications/domain/repositories/notifications_repository.dart';

class GetInAppNotificationsUseCase {
  final NotificationsRepository repository;

  GetInAppNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call() {
    return repository.getInAppNotifications();
  }
}
