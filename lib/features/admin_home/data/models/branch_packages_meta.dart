class BranchPackagesMeta {
  final int totalPackageCount;
  final int activePackagesCount;
  final double averagePrice;

  BranchPackagesMeta({
    required this.totalPackageCount,
    required this.activePackagesCount,
    required this.averagePrice,
  });

  factory BranchPackagesMeta.fromJson(Map<String, dynamic> json) {
    return BranchPackagesMeta(
      totalPackageCount: json['totalPackageCount'] ?? 0,
      activePackagesCount: json['activePackagesCount'] ?? 0,
      averagePrice: (json['averagePrice'] as num?)?.toDouble() ?? 0,
    );
  }
}
