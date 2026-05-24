import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/data/datasources/package_remote_datasource.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_package_item.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_packages_meta.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_packages_response.dart';
import 'package:gymbook/features/admin/admin_home/data/models/create_package_request.dart';
import 'package:gymbook/features/admin/admin_home/data/models/create_package_response.dart';
import 'package:gymbook/features/admin/admin_home/data/models/update_package_request.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/created_package_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/package_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/packages_list_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/packages_meta_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/package_repository.dart';

class PackageRepositoryImpl implements PackageRepository {
  final PackageRemoteDataSource remoteDataSource;

  PackageRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CreatedPackageEntity>> createPackage({
    required int branchId,
    required String name,
    required double price,
    required int durationInMonths,
    required bool isActive,
    required int numberOfFreezes,
    required int freezeDurationInDays,
  }) async {
    try {
      final request = CreatePackageRequest(
        branchId: branchId,
        name: name,
        price: price,
        durationInMonths: durationInMonths,
        isActive: isActive,
        numberOfFreezes: numberOfFreezes,
        freezeDurationInDays: freezeDurationInDays,
      );
      final model = await remoteDataSource.createPackage(
        branchId: branchId,
        request: request,
      );
      return Right(_mapCreatedPackage(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, CreatedPackageEntity>> updatePackage({
    required int branchId,
    required int packageId,
    required String name,
    required double price,
    required int durationInMonths,
    required bool isActive,
    required int numberOfFreezes,
    required int freezeDurationInDays,
  }) async {
    try {
      final request = UpdatePackageRequest(
        name: name,
        price: price,
        durationInMonths: durationInMonths,
        isActive: isActive,
        numberOfFreezes: numberOfFreezes,
        freezeDurationInDays: freezeDurationInDays,
      );
      final model = await remoteDataSource.updatePackage(
        branchId: branchId,
        packageId: packageId,
        request: request,
      );
      return Right(_mapCreatedPackage(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, PackagesListEntity>> getBranchPackages({
    required int branchId,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final model = await remoteDataSource.getBranchPackages(
        branchId: branchId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(_mapPackagesList(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updatePackageStatus({
    required int branchId,
    required int packageId,
    required bool isActive,
  }) async {
    try {
      await remoteDataSource.updatePackageStatus(
        branchId: branchId,
        packageId: packageId,
        isActive: isActive,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deletePackage({
    required int branchId,
    required int packageId,
  }) async {
    try {
      await remoteDataSource.deletePackage(
        branchId: branchId,
        packageId: packageId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  PackageEntity _mapPackageItem(BranchPackageItem m) {
    return PackageEntity(
      id: m.id,
      name: m.name,
      price: m.price,
      durationInMonths: m.durationInMonths,
      isActive: m.isActive,
      numberOfFreezes: m.numberOfFreezes,
      freezeDurationInDays: m.freezeDurationInDays,
    );
  }

  PackagesMetaEntity _mapPackagesMeta(BranchPackagesMeta m) {
    return PackagesMetaEntity(
      totalPackageCount: m.totalPackageCount,
      activePackagesCount: m.activePackagesCount,
      averagePrice: m.averagePrice,
    );
  }

  PackagesListEntity _mapPackagesList(BranchPackagesResponse m) {
    return PackagesListEntity(
      data: m.data.map(_mapPackageItem).toList(),
      currentPage: m.currentPage,
      totalPages: m.totalPages,
      totalCount: m.totalCount,
      meta: _mapPackagesMeta(m.meta),
      pageSize: m.pageSize,
      hasPreviousPage: m.hasPreviousPage,
      hasNextPage: m.hasNextPage,
    );
  }

  CreatedPackageEntity _mapCreatedPackage(CreatePackageResponse m) {
    return CreatedPackageEntity(
      packageId: m.packageId,
      name: m.name,
      price: m.price,
      durationInMonths: m.durationInMonths,
      isActive: m.isActive,
      numberOfFreezes: m.numberOfFreezes,
      freezeDurationInDays: m.freezeDurationInDays,
    );
  }
}
