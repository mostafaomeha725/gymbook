class CreatedPackageEntity {
  final int packageId;
  final String name;
  final double price;
  final int durationInMonths;
  final bool isActive;
  final int numberOfFreezes;
  final int freezeDurationInDays;

  const CreatedPackageEntity({
    required this.packageId,
    required this.name,
    required this.price,
    required this.durationInMonths,
    required this.isActive,
    required this.numberOfFreezes,
    required this.freezeDurationInDays,
  });
}
