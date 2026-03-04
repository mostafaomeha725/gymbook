import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/domain/entities/packages_list_entity.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branch_packages_usecase.dart';

part 'branch_packages_list_state.dart';

class BranchPackagesListCubit extends Cubit<BranchPackagesListState> {
  BranchPackagesListCubit(this.getBranchPackagesUseCase)
    : super(BranchPackagesListInitial());

  final GetBranchPackagesUseCase getBranchPackagesUseCase;

  int _currentPage = 1;
  static const int _pageSize = 10;

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

    emit(BranchPackagesListLoading());
    showLoading();

    final result = await getBranchPackagesUseCase(
      branchId: branchId,
      pageNumber: _currentPage,
      pageSize: _pageSize,
    );

    result.fold(
      (failure) {
        hideLoading();
        emit(BranchPackagesListFailure(failure.message));
      },
      (entity) {
        hideLoading();
        emit(BranchPackagesListSuccess(entity));
      },
    );
  }
}
