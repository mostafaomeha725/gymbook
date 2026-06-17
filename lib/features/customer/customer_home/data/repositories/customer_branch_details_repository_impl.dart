import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_home/data/datasources/customer_branch_details_remote_datasource.dart';
import 'package:gymbook/features/customer/customer_home/data/models/customer_branch_details_model.dart';
import 'package:gymbook/features/customer/customer_home/domain/repositories/customer_branch_details_repository.dart';

class CustomerBranchDetailsRepositoryImpl
    implements CustomerBranchDetailsRepository {
  final CustomerBranchDetailsRemoteDataSource remoteDataSource;

  CustomerBranchDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CustomerBranchDetailsModel>> getBranchDetails({
    required int branchId,
  }) async {
    try {
      final model = await remoteDataSource.getBranchDetails(branchId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
