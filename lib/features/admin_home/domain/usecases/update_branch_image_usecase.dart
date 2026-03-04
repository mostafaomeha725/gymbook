import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class UpdateBranchImageUseCase {
  final AdminBranchRepository repository;

  UpdateBranchImageUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required int branchId,
    required int imageId,
    required File imageFile,
  }) {
    return repository.updateBranchImage(
      branchId: branchId,
      imageId: imageId,
      imageFile: imageFile,
    );
  }
}
