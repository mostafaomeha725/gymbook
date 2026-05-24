import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_home/domain/entities/nearby_branches_page_entity.dart';

abstract class NearbyBranchesRepository {
  Future<Either<Failure, NearbyBranchesPageEntity>> getNearbyBranches({
    double? latitude,
    double? longitude,
    required int radiusInMeters,
    required int pageNumber,
    required int pageSize,
    String? search,
  });
}
