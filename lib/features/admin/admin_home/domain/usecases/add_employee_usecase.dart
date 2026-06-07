import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/data/models/employee_model.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/employees_repository.dart';

class AddEmployeeUseCase {
  final EmployeesRepository repository;

  AddEmployeeUseCase(this.repository);

  Future<Either<Failure, EmployeeModel>> call(Map<String, dynamic> body) async {
    return await repository.addEmployee(body);
  }
}
