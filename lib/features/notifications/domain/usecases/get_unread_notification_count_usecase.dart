import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/notifications/domain/repositories/notifications_repository.dart';

class GetUnreadNotificationCountUseCase {
  final NotificationsRepository repository;

  GetUnreadNotificationCountUseCase(this.repository);

  Future<Either<Failure, int>> call() {
    return repository.getUnreadNotificationCount();
  }
}
