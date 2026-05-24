import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/data/models/admin_me_response_model.dart';

abstract class AdminMeRemoteDataSource {
  Future<List<AdminMeBranchModel>> getMyBranches();
}

class AdminMeRemoteDataSourceImpl implements AdminMeRemoteDataSource {
  final NetworkService networkService;

  AdminMeRemoteDataSourceImpl(this.networkService);

  @override
  Future<List<AdminMeBranchModel>> getMyBranches() async {
    final response = await networkService.getData(
      endPoint: EndPoints.getCurrentUser,
    );

    return response.fold((failure) => throw ServerException(failure.message), (
      data,
    ) {
      final parsed = AdminMeResponseModel.fromJson(
        data as Map<String, dynamic>,
      );
      return parsed.branches;
    });
  }
}
