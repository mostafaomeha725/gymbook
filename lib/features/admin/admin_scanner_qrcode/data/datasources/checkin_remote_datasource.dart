import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';

abstract class CheckInRemoteDataSource {
  Future<void> addCheckIn({
    required int customerId,
    required String code,
    required int branchId,
  });
}

class CheckInRemoteDataSourceImpl implements CheckInRemoteDataSource {
  final NetworkService networkService;

  CheckInRemoteDataSourceImpl(this.networkService);

  @override
  Future<void> addCheckIn({
    required int customerId,
    required String code,
    required int branchId,
  }) async {
    final response = await networkService.postData(
      endPoint: EndPoints.addCheckIn,
      data: {'customerId': customerId, 'code': code, 'branchId': branchId},
    );

    response.fold((failure) => throw ServerException(failure.message), (_) {});
  }
}
