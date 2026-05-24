class CreatedBranchEntity {
  final int id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final int? branchType;

  const CreatedBranchEntity({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.branchType,
  });
}
