import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_list_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_setup_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_statistics_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/created_branch_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/uploaded_branch_image_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_reviews_entity.dart';

abstract class BranchRepository {
  Future<Either<Failure, CreatedBranchEntity>> createBranch({
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  });

  Future<Either<Failure, void>> editBranch({
    required int branchId,
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  });

  Future<Either<Failure, void>> updateBranchWorkingHours({
    required int branchId,
    required List<Map<String, dynamic>> workingHours,
  });

  Future<Either<Failure, void>> updateBranchLocationDetails({
    required int branchId,
    required int governorateId,
    required String address,
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, void>> updateBranchStatus({
    required int branchId,
    required int branchStatus,
  });

  Stream<Either<Failure, BranchListEntity>> getBranches({
    int pageNumber = 1,
    int pageSize = 10,
    String? search,
  });

  Stream<Either<Failure, BranchDetailsEntity>> getBranchDetails(int branchId);

  Stream<Either<Failure, BranchSetupDetailsEntity>> getBranchSetupDetails(
    int branchId,
  );

  Future<Either<Failure, UploadedBranchImageEntity>> uploadBranchImage({
    required int branchId,
    required File imageFile,
    int? imageType,
    int? displayOrder,
  });

  Future<Either<Failure, UploadedBranchImageEntity>> updateBranchImage({
    required int branchId,
    required int imageId,
    required File imageFile,
  });

  Future<Either<Failure, void>> activateBranchImages({
    required int branchId,
    required List<int> imageIds,
  });

  Stream<Either<Failure, BranchStatisticsEntity>> getBranchStatistics({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  });

  Stream<Either<Failure, BranchStatisticsEntity>> getAllBranchesStatistics({
    required StatisticsTimePeriod timePeriod,
  });

  Future<Either<Failure, BranchReviewsEntity>> getBranchReviews({
    required int branchId,
    int pageNumber = 1,
    int pageSize = 10,
    double? rating,
  });
}
