import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/data/datasources/checkin_remote_datasource.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/domain/repositories/checkin_repository.dart';

class CheckInRepositoryImpl implements CheckInRepository {
  final CheckInRemoteDataSource remoteDataSource;

  CheckInRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> addCheckIn({
    required int customerId,
    required String code,
    required int branchId,
  }) async {
    try {
      await remoteDataSource.addCheckIn(
        customerId: customerId,
        code: code,
        branchId: branchId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
