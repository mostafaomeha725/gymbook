import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/data/models/checkin_result_model.dart';

abstract class CheckInRemoteDataSource {
  Future<CheckInResultModel> addCheckIn({
    required int customerId,
    required String code,
    required int branchId,
  });
}

class CheckInRemoteDataSourceImpl implements CheckInRemoteDataSource {
  final NetworkService networkService;

  CheckInRemoteDataSourceImpl(this.networkService);

  @override
  Future<CheckInResultModel> addCheckIn({
    required int customerId,
    required String code,
    required int branchId,
  }) async {
    final response = await networkService.postData(
      endPoint: EndPoints.addCheckIn,
      data: {'customerId': customerId, 'code': code, 'branchId': branchId},
    );

    return response.fold((failure) => throw ServerException(failure.message), (
      data,
    ) {
      if (data is Map<String, dynamic>) {
        return CheckInResultModel.fromJson(data);
      }
      // Fallback if API returns something unexpected
      return const CheckInResultModel(
        memberName: '',
        packageName: '',
        lastCheckIn: '',
      );
    });
  }
}
