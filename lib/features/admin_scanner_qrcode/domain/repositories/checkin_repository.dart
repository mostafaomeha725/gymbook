import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';

abstract class CheckInRepository {
  Future<Either<Failure, void>> addCheckIn({
    required int customerId,
    required String code,
    required int branchId,
  });
}
