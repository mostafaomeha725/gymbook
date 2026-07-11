import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/data/models/checkin_result_model.dart';

abstract class CheckInRepository {
  Future<Either<Failure, CheckInResultModel>> addCheckIn({
    required int customerId,
    required String code,
    required int branchId,
  });
}
