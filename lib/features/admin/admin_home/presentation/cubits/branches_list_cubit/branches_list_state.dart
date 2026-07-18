import 'package:gymbook/features/admin/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_list_entity.dart';

sealed class BranchesListState {}

final class BranchesListInitial extends BranchesListState {}

final class BranchesListLoading extends BranchesListState {}

final class BranchesListSuccess extends BranchesListState {
  final BranchListEntity response;
  final List<BranchEntity> items;
  final bool isFetchingMore;
  final bool hasReachedMax;

  BranchesListSuccess({
    required this.response,
    required this.items,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
  });

  BranchesListSuccess copyWith({
    BranchListEntity? response,
    List<BranchEntity>? items,
    bool? isFetchingMore,
    bool? hasReachedMax,
  }) {
    return BranchesListSuccess(
      response: response ?? this.response,
      items: items ?? this.items,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

final class BranchesListFailure extends BranchesListState {
  final String message;
  BranchesListFailure(this.message);
}
