class AddEditEmployeeScreenArgs {
  final int branchId;
  final bool isEditMode;
  final dynamic employee;

  const AddEditEmployeeScreenArgs({
    required this.branchId,
    this.isEditMode = false,
    this.employee,
  });
}
