import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, void>> updateFcmToken(String token);
}
