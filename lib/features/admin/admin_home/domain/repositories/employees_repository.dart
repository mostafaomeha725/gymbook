import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/data/models/role_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/employee_model.dart';

abstract class EmployeesRepository {
  Future<Either<Failure, List<RoleModel>>> getRoles();
  Stream<Either<Failure, BranchEmployeesResponse>> getBranchEmployees(
    int branchId,
    int pageNumber,
  );
  Future<Either<Failure, EmployeeModel>> addEmployee(Map<String, dynamic> body);
  Future<Either<Failure, EmployeeModel>> updateEmployee(
    int employeeId,
    Map<String, dynamic> body,
  );
}
