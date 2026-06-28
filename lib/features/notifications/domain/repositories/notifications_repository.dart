import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, void>> updateFcmToken(String token);
  Future<Either<Failure, List<NotificationEntity>>> getInAppNotifications();
  Future<Either<Failure, void>> markNotificationAsRead(int id);
}
