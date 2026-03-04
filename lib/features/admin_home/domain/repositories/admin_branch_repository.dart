import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_details_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_list_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/created_branch_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/created_package_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/packages_list_entity.dart';

abstract class AdminBranchRepository {
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

  Future<Either<Failure, BranchListEntity>> getBranches({
    int pageNumber = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, BranchDetailsEntity>> getBranchDetails(int branchId);

  Future<Either<Failure, CreatedPackageEntity>> createPackage({
    required int branchId,
    required String name,
    required double price,
    required int durationInMonths,
    required bool isActive,
    required int numberOfFreezes,
    required int freezeDurationInDays,
  });

  Future<Either<Failure, CreatedPackageEntity>> updatePackage({
    required int branchId,
    required int packageId,
    required String name,
    required double price,
    required int durationInMonths,
    required bool isActive,
    required int numberOfFreezes,
    required int freezeDurationInDays,
  });

  Future<Either<Failure, PackagesListEntity>> getBranchPackages({
    required int branchId,
    required int pageNumber,
    required int pageSize,
  });

  Future<Either<Failure, void>> updatePackageStatus({
    required int branchId,
    required int packageId,
    required bool isActive,
  });

  Future<Either<Failure, void>> deletePackage({
    required int branchId,
    required int packageId,
  });

  Future<Either<Failure, String>> uploadBranchImage({
    required int branchId,
    required File imageFile,
  });

  Future<Either<Failure, String>> updateBranchImage({
    required int branchId,
    required int imageId,
    required File imageFile,
  });
}
