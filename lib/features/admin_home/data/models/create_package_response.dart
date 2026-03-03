class CreatePackageResponse {
  final int packageId;
  final String name;
  final double price;
  final int durationInMonths;
  final bool isActive;
  final int numberOfFreezes;
  final int freezeDurationInDays;

  CreatePackageResponse({
    required this.packageId,
    required this.name,
    required this.price,
    required this.durationInMonths,
    required this.isActive,
    required this.numberOfFreezes,
    required this.freezeDurationInDays,
  });

  factory CreatePackageResponse.fromJson(Map<String, dynamic> json) =>
      CreatePackageResponse(
        packageId: json['packageId'] ?? 0,
        name: json['name'] ?? '',
        price: (json['price'] as num).toDouble(),
        durationInMonths: json['durationInMonths'] ?? 0,
        isActive: json['isActive'] ?? true,
        numberOfFreezes: json['numberOfFreezes'] ?? 0,
        freezeDurationInDays: json['freezeDurationInDays'] ?? 0,
      );
}
