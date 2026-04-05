class UploadedBranchImageEntity {
  final int id;
  final String url;
  final int imageType;
  final int displayOrder;

  const UploadedBranchImageEntity({
    required this.id,
    required this.url,
    required this.imageType,
    required this.displayOrder,
  });
}
