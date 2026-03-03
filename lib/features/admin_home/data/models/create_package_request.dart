class CreatePackageRequest {
  final int branchId;
  final String name;
  final double price;
  final int durationInMonths;
  final bool isActive;
  final int numberOfFreezes;
  final int freezeDurationInDays;

  CreatePackageRequest({
    required this.branchId,
    required this.name,
    required this.price,
    required this.durationInMonths,
    this.isActive = true,
    this.numberOfFreezes = 0,
    this.freezeDurationInDays = 0,
  });

  Map<String, dynamic> toJson() => {
    'branchId': branchId,
    'name': name,
    'price': price,
    'durationInMonths': durationInMonths,
    'isActive': isActive,
    'numberOfFreezes': numberOfFreezes,
    'freezeDurationInDays': freezeDurationInDays,
  };
}
