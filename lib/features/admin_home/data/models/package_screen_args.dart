import 'package:gymbook/features/admin_home/domain/entities/package_entity.dart';

class PackageScreenArgs {
  final int branchId;
  final PackageEntity? packageItem;

  const PackageScreenArgs({required this.branchId, this.packageItem});

  bool get isEditMode => packageItem != null;
}
