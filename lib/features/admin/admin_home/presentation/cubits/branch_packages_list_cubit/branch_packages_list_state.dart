import 'package:gymbook/features/admin/admin_home/domain/entities/package_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/packages_list_entity.dart';

sealed class BranchPackagesListState {}

final class BranchPackagesListInitial extends BranchPackagesListState {}

final class BranchPackagesListLoading extends BranchPackagesListState {}

final class BranchPackagesListSuccess extends BranchPackagesListState {
  final PackagesListEntity response;
  final List<PackageEntity> items;
  final bool isFetchingMore;
  final bool hasReachedMax;

  BranchPackagesListSuccess({
    required this.response,
    required this.items,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
  });

  BranchPackagesListSuccess copyWith({
    PackagesListEntity? response,
    List<PackageEntity>? items,
    bool? isFetchingMore,
    bool? hasReachedMax,
  }) {
    return BranchPackagesListSuccess(
      response: response ?? this.response,
      items: items ?? this.items,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

final class BranchPackagesListFailure extends BranchPackagesListState {
  final String message;

  BranchPackagesListFailure(this.message);
}
