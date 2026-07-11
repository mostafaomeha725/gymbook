import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/data/models/employee_model.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/employees_repository.dart';

class GetBranchEmployeesUseCase {
  final EmployeesRepository repository;

  GetBranchEmployeesUseCase(this.repository);

  Stream<Either<Failure, BranchEmployeesResponse>> call(
    int branchId,
    int pageNumber,
  ) {
    return repository.getBranchEmployees(branchId, pageNumber);
  }
}
