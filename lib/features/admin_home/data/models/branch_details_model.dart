import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';

class BranchImageModel {
  final int id;
  final int type; // 0 = Logo, 1 = MarketPlace
  final String url;

  BranchImageModel({required this.id, required this.type, required this.url});

  factory BranchImageModel.fromJson(Map<String, dynamic> json) {
    return BranchImageModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? 0,
      url: json['url'] ?? '',
    );
  }
}

class BranchDetailsResponse {
  final int id;
  final String name;
  final int branchType;
  final int branchStatus;
  final List<BranchImageModel> images;
  final BranchGovernorate? governorate;
  final String address;
  final bool isOpenNow;
  final int activePackagesCount;
  final int activeSubscriptionsCount;

  BranchDetailsResponse({
    required this.id,
    required this.name,
    required this.branchType,
    required this.branchStatus,
    required this.images,
    this.governorate,
    required this.address,
    required this.isOpenNow,
    required this.activePackagesCount,
    required this.activeSubscriptionsCount,
  });

  factory BranchDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BranchDetailsResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      branchType: json['branchType'] ?? 0,
      branchStatus: json['branchStatus'] ?? 0,
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => BranchImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      governorate: json['governorate'] != null
          ? BranchGovernorate.fromJson(
              json['governorate'] as Map<String, dynamic>,
            )
          : null,
      address: json['address'] ?? '',
      isOpenNow: json['isOpenNow'] ?? false,
      activePackagesCount: json['activePackagesCount'] ?? 0,
      activeSubscriptionsCount: json['activeSubscriptionsCount'] ?? 0,
    );
  }
}
