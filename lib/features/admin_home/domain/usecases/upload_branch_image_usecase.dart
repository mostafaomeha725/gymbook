import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/repositories/branch_repository.dart';

class UploadBranchImageUseCase {
  final BranchRepository repository;

  UploadBranchImageUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required int branchId,
    required File imageFile,
  }) {
    return repository.uploadBranchImage(
      branchId: branchId,
      imageFile: imageFile,
    );
  }
}
