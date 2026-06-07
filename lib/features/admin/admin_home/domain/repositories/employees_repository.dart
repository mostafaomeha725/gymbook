import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/data/models/role_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/employee_model.dart';

abstract class EmployeesRepository {
  Future<Either<Failure, List<RoleModel>>> getRoles();
  Future<Either<Failure, BranchEmployeesResponse>> getBranchEmployees(int branchId, int pageNumber);
}
