import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_home/domain/entities/nearby_branches_page_entity.dart';
import 'package:gymbook/features/customer/customer_home/domain/repositories/nearby_branches_repository.dart';

class GetNearbyBranchesUseCase {
  final NearbyBranchesRepository repository;

  GetNearbyBranchesUseCase(this.repository);

  Stream<Either<Failure, NearbyBranchesPageEntity>> call({
    double? latitude,
    double? longitude,
    required int radiusInMeters,
    required int pageNumber,
    required int pageSize,
    String? search,
  }) {
    return repository.getNearbyBranches(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: radiusInMeters,
      pageNumber: pageNumber,
      pageSize: pageSize,
      search: search,
    );
  }
}
