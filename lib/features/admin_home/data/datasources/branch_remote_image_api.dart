import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/admin_home/data/models/uploaded_branch_image_model.dart';

class BranchRemoteImageApi {
  final NetworkService networkService;

  BranchRemoteImageApi(this.networkService);

  Future<UploadedBranchImageModel> uploadBranchImage({
    required int branchId,
    required File imageFile,
    int? imageType,
    int? displayOrder,
  }) async {
    final fileName = imageFile.path.split(Platform.pathSeparator).last;
    final payload = <String, dynamic>{
      'ImageFile': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
      if (imageType != null) 'ImageType': imageType,
      if (displayOrder != null) 'DisplayOrder': displayOrder,
    };

    final response = await networkService.uploadFile(
      endPoint: EndPoints.addBranchImage(branchId),
      formData: FormData.fromMap(payload),
    );

    return response.fold((failure) => throw ServerException(failure.message), (
      data,
    ) {
      final model = UploadedBranchImageModel.fromUploadResponse(
        data,
        fallbackImageType: imageType ?? 1,
        fallbackDisplayOrder: displayOrder ?? 1,
      );

      if (model.id <= 0) {
        throw ServerException('Upload response missing image id');
      }

      return model;
    });
  }

  Future<UploadedBranchImageModel> updateBranchImage({
    required int branchId,
    required int imageId,
    required File imageFile,
  }) async {
    final fileName = imageFile.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'ImageFile': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    try {
      final response = await networkService.dio.patch(
        EndPoints.updateBranchImage(branchId, imageId),
        data: formData,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 299) {
        final model = UploadedBranchImageModel.fromUploadResponse(
          response.data,
          fallbackImageType: 1,
          fallbackDisplayOrder: 1,
        );

        if (model.id <= 0) {
          return UploadedBranchImageModel(
            id: imageId,
            url: model.url,
            imageType: model.imageType,
            displayOrder: model.displayOrder,
          );
        }

        return model;
      }

      final data = response.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw ServerException(data['message'].toString());
      }
      throw ServerException('Error ${response.statusCode}');
    } on DioException catch (error) {
      final handled = networkService.handleDioExceoptions(error);
      return handled.fold(
        (failure) => throw ServerException(failure.message),
        (_) => throw ServerException(error.message ?? 'Request failed'),
      );
    }
  }

  Future<void> activateBranchImages({
    required int branchId,
    required List<int> imageIds,
  }) async {
    final response = await networkService.patchData(
      endPoint: EndPoints.activateBranchImages(branchId),
      data: {'images': imageIds},
    );

    response.fold((failure) => throw ServerException(failure), (_) {});
  }
}
