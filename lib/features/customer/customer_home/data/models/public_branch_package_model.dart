class PublicBranchPackageModel {
  final int id;
  final String name;
  final double price;
  final int durationInMonths;
  final int numberOfFreezes;
  final int freezeDurationInDays;

  const PublicBranchPackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.durationInMonths,
    required this.numberOfFreezes,
    required this.freezeDurationInDays,
  });

  factory PublicBranchPackageModel.fromJson(Map<String, dynamic> json) {
    return PublicBranchPackageModel(
      id: _parseId(json['id'] ?? json['packageId']),
      name: (json['name'] ?? '').toString(),
      price: json['price'] is num ? (json['price'] as num).toDouble() : 0,
      durationInMonths: json['durationInMonths'] is int ? json['durationInMonths'] as int : 0,
      numberOfFreezes: json['numberOfFreezes'] is int ? json['numberOfFreezes'] as int : 0,
      freezeDurationInDays: json['freezeDurationInDays'] is int ? json['freezeDurationInDays'] as int : 0,
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class PublicBranchPackagesResponse {
  final List<PublicBranchPackageModel> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const PublicBranchPackagesResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PublicBranchPackagesResponse.fromJson(Map<String, dynamic> json) {
    return PublicBranchPackagesResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((e) => PublicBranchPackageModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalCount: json['totalCount'] as int? ?? 0,
      pageSize: json['pageSize'] as int? ?? 1,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
    );
  }
}
