import 'package:gymbook/features/admin_home/domain/entities/package_entity.dart';
import 'package:gymbook/features/admin_home/domain/entities/packages_meta_entity.dart';

class PackagesListEntity {
  final List<PackageEntity> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final PackagesMetaEntity meta;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const PackagesListEntity({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.meta,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
}
