import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin_home/data/models/governorate_model.dart';

abstract class GovernoratesRemoteDataSource {
  Future<List<GovernorateModel>> getGovernorates();
}

class GovernoratesRemoteDataSourceImpl implements GovernoratesRemoteDataSource {
  final NetworkService networkService;

  GovernoratesRemoteDataSourceImpl(this.networkService);

  @override
  Future<List<GovernorateModel>> getGovernorates() async {
    final response = await networkService.getData(
      endPoint: EndPoints.getGovernorates,
    );

    return response.fold((failure) => throw ServerException(failure.message), (
      data,
    ) {
      return (data as List<dynamic>)
          .whereType<Map>()
          .map(
            (item) =>
                GovernorateModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .where((item) => item.name.trim().isNotEmpty)
          .toList();
    });
  }
}
