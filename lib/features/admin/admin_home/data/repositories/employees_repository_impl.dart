import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/data/datasources/employees_remote_datasource.dart';
import 'package:gymbook/features/admin/admin_home/data/models/role_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/employee_model.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/employees_repository.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeesRemoteDataSource remoteDataSource;

  EmployeesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<RoleModel>>> getRoles() async {
    try {
      final roles = await remoteDataSource.getRoles();
      return Right(roles);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, BranchEmployeesResponse>> getBranchEmployees(int branchId, int pageNumber) async {
    try {
      final response = await remoteDataSource.getBranchEmployees(branchId, pageNumber);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }
}
