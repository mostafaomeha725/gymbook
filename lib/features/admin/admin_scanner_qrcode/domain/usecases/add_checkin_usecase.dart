import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/data/models/checkin_result_model.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/domain/repositories/checkin_repository.dart';

class AddCheckInUseCase {
  final CheckInRepository repository;

  AddCheckInUseCase(this.repository);

  Future<Either<Failure, CheckInResultModel>> call({
    required int customerId,
    required String code,
    required int branchId,
  }) {
    return repository.addCheckIn(
      customerId: customerId,
      code: code,
      branchId: branchId,
    );
  }
}
