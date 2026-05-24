import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/created_package_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/packages_list_entity.dart';

abstract class PackageRepository {
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
}
