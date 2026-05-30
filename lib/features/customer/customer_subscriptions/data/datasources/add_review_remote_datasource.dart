import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';

abstract class AddReviewRemoteDataSource {
  Future<int> addReview({
    required int branchId,
    required int rating,
    required String comment,
  });

  Future<void> updateReview({
    required int branchId,
    required int reviewId,
    required int rating,
    required String comment,
  });
}

class AddReviewRemoteDataSourceImpl implements AddReviewRemoteDataSource {
  final NetworkService networkService;

  AddReviewRemoteDataSourceImpl(this.networkService);

  @override
  Future<int> addReview({
    required int branchId,
    required int rating,
    required String comment,
  }) async {
    final response = await networkService.postData(
      endPoint: EndPoints.addBranchReview(branchId),
      data: {"rating": rating, "comment": comment},
    );

    return response.fold((failure) => throw ServerException(failure.message), (
      data,
    ) {
      if (data is Map<String, dynamic> && data['id'] != null) {
        return data['id'] as int;
      }
      throw const ServerException('Invalid response: missing review id');
    });
  }

  @override
  Future<void> updateReview({
    required int branchId,
    required int reviewId,
    required int rating,
    required String comment,
  }) async {
    final response = await networkService.putData(
      endPoint: EndPoints.updateBranchReview(branchId, reviewId),
      data: {"rating": rating, "comment": comment},
    );

    return response.fold(
      (failure) => throw ServerException(failure.message),
      (_) => null,
    );
  }
}
