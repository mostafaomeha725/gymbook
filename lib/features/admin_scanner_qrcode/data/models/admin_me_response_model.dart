class AdminMeResponseModel {
  final int id;
  final int userType;
  final String? userRole;
  final List<AdminMeBranchModel> branches;

  AdminMeResponseModel({
    required this.id,
    required this.userType,
    required this.userRole,
    required this.branches,
  });

  factory AdminMeResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminMeResponseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userType: (json['userType'] as num?)?.toInt() ?? 0,
      userRole: json['userRole']?.toString(),
      branches: (json['branches'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map(
            (item) =>
                AdminMeBranchModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .where((item) => item.id > 0)
          .toList(),
    );
  }
}

class AdminMeBranchModel {
  final int id;
  final String name;

  AdminMeBranchModel({required this.id, required this.name});

  factory AdminMeBranchModel.fromJson(Map<String, dynamic> json) {
    return AdminMeBranchModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
    );
  }
}
