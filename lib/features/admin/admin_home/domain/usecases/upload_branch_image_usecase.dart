import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/uploaded_branch_image_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/branch_repository.dart';

class UploadBranchImageUseCase {
  final BranchRepository repository;

  UploadBranchImageUseCase(this.repository);

  Future<Either<Failure, UploadedBranchImageEntity>> call({
    required int branchId,
    required File imageFile,
    int? imageType,
    int? displayOrder,
  }) {
    return repository.uploadBranchImage(
      branchId: branchId,
      imageFile: imageFile,
      imageType: imageType,
      displayOrder: displayOrder,
    );
  }
}
