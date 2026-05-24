import 'package:gymbook/features/admin/admin_home/domain/entities/uploaded_branch_image_entity.dart';

import 'uploaded_branch_image_parsing.dart';

class UploadedBranchImageModel {
  final int id;
  final String url;
  final int imageType;
  final int displayOrder;

  const UploadedBranchImageModel({
    required this.id,
    required this.url,
    required this.imageType,
    required this.displayOrder,
  });

  UploadedBranchImageEntity toEntity() {
    return UploadedBranchImageEntity(
      id: id,
      url: url,
      imageType: imageType,
      displayOrder: displayOrder,
    );
  }

  static UploadedBranchImageModel fromUploadResponse(
    dynamic response, {
    required int fallbackImageType,
    required int fallbackDisplayOrder,
  }) {
    final payload = UploadedBranchImageParsing.extractPayload(response);
    final id =
        UploadedBranchImageParsing.asInt(payload?['imageId']) ??
        UploadedBranchImageParsing.asInt(payload?['id']) ??
        0;
    final url =
        UploadedBranchImageParsing.asString(payload?['imageUrl']) ??
        UploadedBranchImageParsing.asString(payload?['url']) ??
        UploadedBranchImageParsing.asString(payload?['image']) ??
        '';

    final imageType =
        UploadedBranchImageParsing.asInt(payload?['imageType']) ??
        UploadedBranchImageParsing.asInt(payload?['type']) ??
        fallbackImageType;

    final displayOrder =
        UploadedBranchImageParsing.asInt(payload?['displayOrder']) ??
        fallbackDisplayOrder;

    return UploadedBranchImageModel(
      id: id,
      url: url,
      imageType: imageType,
      displayOrder: displayOrder,
    );
  }
}
