class BranchPackageItem {
  final int id;
  final String name;
  final double price;
  final int durationInMonths;
  final bool isActive;
  final int numberOfFreezes;
  final int freezeDurationInDays;

  BranchPackageItem({
    required this.id,
    required this.name,
    required this.price,
    required this.durationInMonths,
    required this.isActive,
    required this.numberOfFreezes,
    required this.freezeDurationInDays,
  });

  factory BranchPackageItem.fromJson(Map<String, dynamic> json) {
    return BranchPackageItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      durationInMonths: json['durationInMonths'] ?? 0,
      isActive: json['isActive'] ?? false,
      numberOfFreezes: json['numberOfFreezes'] ?? 0,
      freezeDurationInDays: json['freezeDurationInDays'] ?? 0,
    );
  }
}
