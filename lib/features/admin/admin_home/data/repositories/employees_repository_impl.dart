import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:gymbook/core/cache/hive_boxes.dart';
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
  Stream<Either<Failure, BranchEmployeesResponse>> getBranchEmployees(int branchId, int pageNumber) async* {
    final String cacheKey = 'branch_employees_${branchId}_page_$pageNumber';
    bool emittedCache = false;

    // 1. Emit Cache if valid
    final cachedJson = Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final Map<String, dynamic> wrapper = jsonDecode(cachedJson);
        final Map<String, dynamic>? dataMap = wrapper['data'];

        if (dataMap != null) {
          final model = BranchEmployeesResponse.fromJson(dataMap);
          emittedCache = true;
          yield Right(model);
        }
      } catch (_) {}
    }

    // 2. Fetch from Network
    try {
      final remoteModel = await remoteDataSource.getBranchEmployees(branchId, pageNumber);
      final remoteJsonString = jsonEncode(remoteModel.toJson());

      // Retrieve current cache to compare
      bool shouldUpdateCacheAndEmit = true;
      if (emittedCache) {
        final currentCachedJson = Hive.box<String>(HiveBoxes.cacheBox).get(cacheKey);
        if (currentCachedJson != null && currentCachedJson.isNotEmpty) {
          try {
            final wrapper = jsonDecode(currentCachedJson);
            final cachedDataString = jsonEncode(wrapper['data']);
            if (remoteJsonString == cachedDataString) {
              shouldUpdateCacheAndEmit = false;
            }
          } catch (_) {}
        }
      }

      if (shouldUpdateCacheAndEmit) {
        final newCacheWrapper = {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'data': remoteModel.toJson(),
        };
        await Hive.box<String>(HiveBoxes.cacheBox).put(cacheKey, jsonEncode(newCacheWrapper));
        yield Right(remoteModel);
      }
    } catch (e) {
      if (!emittedCache) {
        if (e is ServerException) {
          yield Left(ServerFailure(message: e.message));
        } else {
          yield const Left(ServerFailure(message: "Network Error"));
        }
      }
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> addEmployee(Map<String, dynamic> body) async {
    try {
      final response = await remoteDataSource.addEmployee(body);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> updateEmployee(int employeeId, Map<String, dynamic> body) async {
    try {
      final response = await remoteDataSource.updateEmployee(employeeId, body);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }
}
