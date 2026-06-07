import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/data/models/role_model.dart';
import 'package:gymbook/features/admin/admin_home/domain/repositories/employees_repository.dart';

class GetRolesUseCase {
  final EmployeesRepository repository;

  GetRolesUseCase(this.repository);

  Future<Either<Failure, List<RoleModel>>> call() async {
    return await repository.getRoles();
  }
}
