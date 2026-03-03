class UpdatePackageRequest {
  final String name;
  final double price;
  final int durationInMonths;
  final bool isActive;
  final int numberOfFreezes;
  final int freezeDurationInDays;

  UpdatePackageRequest({
    required this.name,
    required this.price,
    required this.durationInMonths,
    required this.isActive,
    required this.numberOfFreezes,
    required this.freezeDurationInDays,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'durationInMonths': durationInMonths,
    'isActive': isActive,
    'numberOfFreezes': numberOfFreezes,
    'freezeDurationInDays': freezeDurationInDays,
  };
}
