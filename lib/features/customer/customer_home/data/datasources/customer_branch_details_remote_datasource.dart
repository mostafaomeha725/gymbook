import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/customer/customer_home/data/models/customer_branch_details_model.dart';

abstract class CustomerBranchDetailsRemoteDataSource {
  Future<CustomerBranchDetailsModel> getBranchDetails(int branchId);
}

class CustomerBranchDetailsRemoteDataSourceImpl implements CustomerBranchDetailsRemoteDataSource {
  final NetworkService networkService;

  CustomerBranchDetailsRemoteDataSourceImpl(this.networkService);

  @override
  Future<CustomerBranchDetailsModel> getBranchDetails(int branchId) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getBranchDetails(branchId),
    );

    return response.fold(
      (failure) => throw ServerException(failure.message),
      (data) => CustomerBranchDetailsModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
