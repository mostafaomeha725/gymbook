import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_scanner_qrcode/domain/entities/admin_branch_option_entity.dart';

abstract class AdminMeRepository {
  Future<Either<Failure, List<AdminBranchOptionEntity>>> getMyBranches();
}
