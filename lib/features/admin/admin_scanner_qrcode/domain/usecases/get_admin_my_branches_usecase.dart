import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/domain/entities/admin_branch_option_entity.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/domain/repositories/admin_me_repository.dart';

class GetAdminMyBranchesUseCase {
  final AdminMeRepository repository;

  GetAdminMyBranchesUseCase(this.repository);

  Future<Either<Failure, List<AdminBranchOptionEntity>>> call() {
    return repository.getMyBranches();
  }
}
