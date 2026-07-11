import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/packages_list_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_packages_usecase.dart';

part 'branch_packages_list_state.dart';

class BranchPackagesListCubit extends Cubit<BranchPackagesListState> {
  BranchPackagesListCubit(this.getBranchPackagesUseCase)
    : super(BranchPackagesListInitial());

  final GetBranchPackagesUseCase getBranchPackagesUseCase;
  StreamSubscription? _subscription;

  int _currentPage = 1;
  static const int _pageSize = 5;

  Future<void> loadPackages({
    required int branchId,
    bool refresh = false,
    int? pageNumber,
  }) async {
    if (refresh) {
      _currentPage = 1;
    } else if (pageNumber != null && pageNumber > 0) {
      _currentPage = pageNumber;
    }

    if (state is! BranchPackagesListSuccess) {
      emit(BranchPackagesListLoading());
    }

    _subscription?.cancel();
    _subscription =
        getBranchPackagesUseCase(
          branchId: branchId,
          pageNumber: _currentPage,
          pageSize: _pageSize,
        ).listen((result) {
          result.fold(
            (failure) {
              if (state is! BranchPackagesListSuccess) {
                emit(BranchPackagesListFailure(failure.message));
              }
            },
            (entity) {
              emit(BranchPackagesListSuccess(entity));
            },
          );
        });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
