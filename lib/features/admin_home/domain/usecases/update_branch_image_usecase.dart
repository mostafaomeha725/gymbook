import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/uploaded_branch_image_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/branch_repository.dart';

class UpdateBranchImageUseCase {
  final BranchRepository repository;

  UpdateBranchImageUseCase(this.repository);

  Future<Either<Failure, UploadedBranchImageEntity>> call({
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
