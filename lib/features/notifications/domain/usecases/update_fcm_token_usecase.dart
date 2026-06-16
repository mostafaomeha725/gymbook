import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/notifications/domain/repositories/notifications_repository.dart';

class UpdateFcmTokenUseCase {
  final NotificationsRepository _repository;

  UpdateFcmTokenUseCase(this._repository);

  Future<Either<Failure, void>> call(String token) async {
    return await _repository.updateFcmToken(token);
  }
}
