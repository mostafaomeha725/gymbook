import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/created_package_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class CreatePackageUseCase {
  final AdminBranchRepository repository;

  CreatePackageUseCase(this.repository);

  Future<Either<Failure, CreatedPackageEntity>> call({
    required int branchId,
    required String name,
    required double price,
    required int durationInMonths,
    required bool isActive,
    required int numberOfFreezes,
    int freezeDurationInDays = 0,
  }) {
    return repository.createPackage(
      branchId: branchId,
      name: name,
      price: price,
      durationInMonths: durationInMonths,
      isActive: isActive,
      numberOfFreezes: numberOfFreezes,
      freezeDurationInDays: freezeDurationInDays,
    );
  }
}
