import 'package:gymbook/features/admin_home/data/models/branch_package_item.dart';

class PackageScreenArgs {
  final int branchId;
  final BranchPackageItem? packageItem;

  const PackageScreenArgs({required this.branchId, this.packageItem});

  bool get isEditMode => packageItem != null;
}
