import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_list_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branches_usecase.dart';

part 'branches_list_state.dart';

class BranchesListCubit extends Cubit<BranchesListState> {
  BranchesListCubit(this.getBranchesUseCase) : super(BranchesListInitial());

  final GetBranchesUseCase getBranchesUseCase;

  int _currentPage = 1;
  static const int _pageSize = 3;
  String? _currentSearch;
  
  StreamSubscription? _branchesSubscription;

  Future<void> loadBranches({
    bool refresh = false,
    int? pageNumber,
    String? search,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _currentSearch = null;
    } else {
      if (pageNumber != null && pageNumber > 0) _currentPage = pageNumber;
      if (search != null) {
        _currentSearch = search.trim().isEmpty ? null : search.trim();
        _currentPage = 1;
      }
    }

    _branchesSubscription?.cancel();
    emit(BranchesListLoading());

    _branchesSubscription = getBranchesUseCase(
      pageNumber: _currentPage,
      pageSize: _pageSize,
      search: _currentSearch,
    ).listen((result) {
      result.fold(
        (failure) {
          if (state is! BranchesListSuccess) {
            emit(BranchesListFailure(failure.message));
          }
        },
        (entity) => emit(BranchesListSuccess(entity)),
      );
    });
  }

  @override
  Future<void> close() {
    _branchesSubscription?.cancel();
    return super.close();
  }
}
