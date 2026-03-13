import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/data/datasources/admin_branch_remote_datasource.dart';
import 'package:gymbook/features/admin_home/data/models/branch_details_model.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/data/models/branch_package_item.dart';
import 'package:gymbook/features/admin_home/data/models/branch_packages_meta.dart';
import 'package:gymbook/features/admin_home/data/models/branch_packages_response.dart';
import 'package:gymbook/features/admin_home/data/models/create_branch_model.dart';
import 'package:gymbook/features/admin_home/data/models/create_package_request.dart';
import 'package:gymbook/features/admin_home/data/models/create_package_response.dart';
import 'package:gymbook/features/admin_home/data/models/update_package_request.dart';
import 'package:gymbook/features/admin_home/data/models/branch_subscriptions_model.dart';
import 'package:gymbook/features/admin_home/domain/entities/add_member_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/add_subscription_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/subscription_item_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/subscription_details_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_details_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_list_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_statistics_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/created_branch_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/created_package_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/governorate_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/package_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/packages_list_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/packages_meta_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class AdminBranchRepositoryImpl implements AdminBranchRepository {
  final AdminBranchRemoteDataSource remoteDataSource;

  AdminBranchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CreatedBranchEntity>> createBranch({
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) async {
    try {
      final model = await remoteDataSource.createBranch(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        branchType: branchType,
      );
      return Right(_mapCreatedBranch(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> editBranch({
    required int branchId,
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) async {
    try {
      await remoteDataSource.editBranch(
        branchId: branchId,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        branchType: branchType,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateBranchWorkingHours({
    required int branchId,
    required List<Map<String, dynamic>> workingHours,
  }) async {
    try {
      await remoteDataSource.updateBranchWorkingHours(
        branchId: branchId,
        workingHours: workingHours,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateBranchLocationDetails({
    required int branchId,
    required int governorateId,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await remoteDataSource.updateBranchLocationDetails(
        branchId: branchId,
        governorateId: governorateId,
        address: address,
        latitude: latitude,
        longitude: longitude,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateBranchStatus({
    required int branchId,
    required int branchStatus,
  }) async {
    try {
      await remoteDataSource.updateBranchStatus(
        branchId: branchId,
        branchStatus: branchStatus,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BranchListEntity>> getBranches({
    int pageNumber = 1,
    int pageSize = 10,
    String? search,
  }) async {
    try {
      final model = await remoteDataSource.getBranches(
        pageNumber: pageNumber,
        pageSize: pageSize,
        search: search,
      );
      return Right(_mapBranchList(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BranchDetailsEntity>> getBranchDetails(
    int branchId,
  ) async {
    try {
      final model = await remoteDataSource.getBranchDetails(branchId);
      return Right(_mapBranchDetails(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

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

  @override
  Future<Either<Failure, String>> uploadBranchImage({
    required int branchId,
    required File imageFile,
  }) async {
    try {
      final url = await remoteDataSource.uploadBranchImage(
        branchId: branchId,
        imageFile: imageFile,
      );
      return Right(url);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> updateBranchImage({
    required int branchId,
    required int imageId,
    required File imageFile,
  }) async {
    try {
      final url = await remoteDataSource.updateBranchImage(
        branchId: branchId,
        imageId: imageId,
        imageFile: imageFile,
      );
      return Right(url);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  // ─── Mappers ───────────────────────────────────────────────────────────────

  CreatedBranchEntity _mapCreatedBranch(CreateBranchResponse m) {
    return CreatedBranchEntity(
      id: m.id,
      name: m.name,
      email: m.email,
      phoneNumber: m.phoneNumber,
      branchType: m.branchType,
    );
  }

  GovernorateEntity? _mapGovernorate(BranchGovernorate? m) {
    if (m == null) return null;
    return GovernorateEntity(id: m.id, name: m.name);
  }

  BranchEntity _mapBranchItem(BranchItem m) {
    return BranchEntity(
      id: m.id,
      name: m.name,
      email: m.email,
      phoneNumber: m.phoneNumber,
      governorate: _mapGovernorate(m.governorate),
      address: m.address,
      latitude: m.latitude,
      longitude: m.longitude,
      branchType: m.branchType,
      branchStatus: m.branchStatus,
      logoImageId: m.logoImageId,
      logo: m.logo,
      subscriptionsCount: m.subscriptionsCount,
    );
  }

  BranchListEntity _mapBranchList(BranchListResponse m) {
    return BranchListEntity(
      data: m.data.map(_mapBranchItem).toList(),
      currentPage: m.currentPage,
      totalPages: m.totalPages,
      totalCount: m.totalCount,
      pageSize: m.pageSize,
      hasPreviousPage: m.hasPreviousPage,
      hasNextPage: m.hasNextPage,
    );
  }

  BranchDetailsEntity _mapBranchDetails(BranchDetailsResponse m) {
    return BranchDetailsEntity(
      id: m.id,
      name: m.name,
      branchType: m.branchType,
      branchStatus: m.branchStatus,
      images: m.images
          .map(
            (img) =>
                BranchImageEntity(id: img.id, type: img.type, url: img.url),
          )
          .toList(),
      governorate: _mapGovernorate(m.governorate),
      address: m.address,
      isOpenNow: m.isOpenNow,
      activePackagesCount: m.activePackagesCount,
      activeSubscriptionsCount: m.activeSubscriptionsCount,
    );
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

  @override
  Future<Either<Failure, BranchStatisticsEntity>> getBranchStatistics({
    required int branchId,
    required StatisticsTimePeriod timePeriod,
  }) async {
    try {
      final model = await remoteDataSource.getBranchStatistics(
        branchId: branchId,
        timePeriod: timePeriod,
      );
      return Right(
        BranchStatisticsEntity(
          branchId: model.branchId,
          newSubscriptionsCount: model.newSubscriptionsCount,
          expiredSubscriptionsCount: model.expiredSubscriptionsCount,
          totalRevenue: model.totalRevenue,
          checkInsCount: model.checkInsCount,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, AddSubscriptionEntity>> addSubscription({
    required int branchId,
    required String email,
    required int packageId,
  }) async {
    try {
      final model = await remoteDataSource.addSubscription(
        branchId: branchId,
        email: email,
        packageId: packageId,
      );
      return Right(AddSubscriptionEntity(id: model.id));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, AddMemberEntity>> addMember({
    required int branchId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required int packageId,
  }) async {
    try {
      final model = await remoteDataSource.addMember(
        branchId: branchId,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        email: email,
        packageId: packageId,
      );
      return Right(AddMemberEntity(id: model.id));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SubscriptionsListEntity>> getBranchSubscriptions({
    required int branchId,
    required int pageNumber,
    required int pageSize,
    String? search,
    int? status,
  }) async {
    try {
      final model = await remoteDataSource.getBranchSubscriptions(
        branchId: branchId,
        pageNumber: pageNumber,
        pageSize: pageSize,
        search: search,
        status: status,
      );
      return Right(_mapSubscriptionsList(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  SubscriptionsListEntity _mapSubscriptionsList(BranchSubscriptionsResponse m) {
    return SubscriptionsListEntity(
      data: m.data.map((item) => item.toEntity()).toList(),
      currentPage: m.currentPage,
      totalPages: m.totalPages,
      totalCount: m.totalCount,
      pageSize: m.pageSize,
      hasPreviousPage: m.hasPreviousPage,
      hasNextPage: m.hasNextPage,
    );
  }

  @override
  Future<Either<Failure, void>> cancelSubscription({
    required int subscriptionId,
  }) async {
    try {
      await remoteDataSource.cancelSubscription(subscriptionId: subscriptionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SubscriptionDetailsEntity>> getSubscriptionDetails(
    int subscriptionId,
  ) async {
    try {
      final model = await remoteDataSource.getSubscriptionDetails(
        subscriptionId,
      );
      return Right(
        SubscriptionDetailsEntity(
          subscriptionId: model.subscriptionId,
          activationDate: DateTime.parse(model.activationDate),
          expirationDate: DateTime.parse(model.expirationDate),
          durationInMonths: model.durationInMonths,
          remainingDays: model.remainingDays,
          paidAmount: model.paidAmount,
          status: model.status,
          packageName: model.packageName,
          totalFreezesCount: model.totalFreezesCount,
          remainingFreezesCount: model.remainingFreezesCount,
          member: SubscriptionMemberEntity(
            fullName: model.member.fullName,
            email: model.member.email,
            phoneNumber: model.member.phoneNumber,
          ),
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
