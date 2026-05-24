import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_home/data/datasources/nearby_branches_remote_datasource.dart';
import 'package:gymbook/features/customer/customer_home/data/models/nearby_branches_response_model.dart';
import 'package:gymbook/features/customer/customer_home/domain/entities/nearby_branch_entity.dart';
import 'package:gymbook/features/customer/customer_home/domain/entities/nearby_branches_page_entity.dart';
import 'package:gymbook/features/customer/customer_home/domain/repositories/nearby_branches_repository.dart';

class NearbyBranchesRepositoryImpl implements NearbyBranchesRepository {
  final NearbyBranchesRemoteDataSource remoteDataSource;

  NearbyBranchesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, NearbyBranchesPageEntity>> getNearbyBranches({
    double? latitude,
    double? longitude,
    required int radiusInMeters,
    required int pageNumber,
    required int pageSize,
    String? search,
  }) async {
    try {
      final model = await remoteDataSource.getNearbyBranches(
        latitude: latitude,
        longitude: longitude,
        radiusInMeters: radiusInMeters,
        pageNumber: pageNumber,
        pageSize: pageSize,
        search: search,
      );

      return Right(_mapPage(model));
    } on ServerException catch (error) {
      return Left(Failure(error.message));
    } catch (error) {
      return Left(Failure(error.toString()));
    }
  }

  NearbyBranchesPageEntity _mapPage(NearbyBranchesResponseModel model) {
    return NearbyBranchesPageEntity(
      data: model.data.map(_mapItem).toList(),
      currentPage: model.currentPage,
      totalPages: model.totalPages,
      totalCount: model.totalCount,
      pageSize: model.pageSize,
      hasPreviousPage: model.hasPreviousPage,
      hasNextPage: model.hasNextPage,
    );
  }

  NearbyBranchEntity _mapItem(NearbyBranchItemModel item) {
    return NearbyBranchEntity(
      id: item.id,
      name: item.name,
      branchType: item.branchType,
      logoUrl: item.logoUrl,
      governate: item.governate,
      address: item.address,
      latitude: item.latitude,
      longitude: item.longitude,
      isOpenNow: item.isOpenNow,
      hasDistance: item.hasDistance,
      distanceInMeters: item.distanceInMeters,
      totalRatings: item.totalRatings,
      averageRating: item.averageRating,
    );
  }
}
