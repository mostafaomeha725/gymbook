import 'package:dartz/dartz.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin_home/data/models/create_branch_model.dart';

abstract class AdminBranchRepository {
  Future<Either<String, CreateBranchResponse>> createBranch({
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  });

  Future<Either<String, void>> updateBranchWorkingHours({
    required int branchId,
    required List<Map<String, dynamic>> workingHours,
  });
}

class AdminBranchRepositoryImpl implements AdminBranchRepository {
  AdminBranchRepositoryImpl(this.networkService);

  final NetworkService networkService;

  @override
  Future<Either<String, CreateBranchResponse>> createBranch({
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) async {
    final response = await networkService.postData(
      endPoint: EndPoints.createBranch,
      data: {
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'branchType': branchType,
      },
    );

    return response.fold(
      (failure) => Left(failure.message),
      (data) =>
          Right(CreateBranchResponse.fromJson(data as Map<String, dynamic>)),
    );
  }

  @override
  Future<Either<String, void>> updateBranchWorkingHours({
    required int branchId,
    required List<Map<String, dynamic>> workingHours,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.updateBranchWorkingHours(branchId),
      data: {'workingHours': workingHours},
    );

    return response.fold((failure) => Left(failure), (_) => const Right(null));
  }
}
