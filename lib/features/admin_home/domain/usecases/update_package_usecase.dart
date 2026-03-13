import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/created_package_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/package_repository.dart';

class UpdatePackageUseCase {
  final PackageRepository repository;

  UpdatePackageUseCase(this.repository);

  Future<Either<Failure, CreatedPackageEntity>> call({
    required int branchId,
    required int packageId,
    required String name,
    required double price,
    required int durationInMonths,
    required bool isActive,
    required int numberOfFreezes,
    int freezeDurationInDays = 0,
  }) {
    return repository.updatePackage(
      branchId: branchId,
      packageId: packageId,
      name: name,
      price: price,
      durationInMonths: durationInMonths,
      isActive: isActive,
      numberOfFreezes: numberOfFreezes,
      freezeDurationInDays: freezeDurationInDays,
    );
  }
}
