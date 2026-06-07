import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin/admin_home/data/models/role_model.dart';
import 'package:gymbook/features/admin/admin_home/data/models/employee_model.dart';

abstract class EmployeesRemoteDataSource {
  Future<List<RoleModel>> getRoles();
  Future<BranchEmployeesResponse> getBranchEmployees(int branchId, int pageNumber);
}

class EmployeesRemoteDataSourceImpl implements EmployeesRemoteDataSource {
  final NetworkService networkService;

  EmployeesRemoteDataSourceImpl(this.networkService);

  @override
  Future<List<RoleModel>> getRoles() async {
    final response = await networkService.getData(
      endPoint: EndPoints.getRoles,
    );

    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) {
        return (data as List<dynamic>)
            .whereType<Map>()
            .map((item) => RoleModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      },
    );
  }
  @override
  Future<BranchEmployeesResponse> getBranchEmployees(int branchId, int pageNumber) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getBranchEmployees(branchId),
      queryParameters: {'PageNumber': pageNumber, 'PageSize': 10},
    );

    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => BranchEmployeesResponse.fromJson(data as Map<String, dynamic>),
    );
  }
}
