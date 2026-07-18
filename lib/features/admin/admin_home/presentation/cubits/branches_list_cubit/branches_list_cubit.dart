import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branches_usecase.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branches_list_cubit/branches_list_state.dart';

class BranchesListCubit extends Cubit<BranchesListState> {
  BranchesListCubit(this.getBranchesUseCase) : super(BranchesListInitial());

  final GetBranchesUseCase getBranchesUseCase;

  int _currentPage = 1;
  static const int _pageSize = 5;
  String? _currentSearch;

  bool _isFetchingMore = false;
  List<BranchEntity> _accumulatedItems = [];

  StreamSubscription? _branchesSubscription;

  Future<void> loadBranches({
    bool refresh = false,
    int? pageNumber,
    String? search,
  }) async {
    bool filtersChanged = false;

    if (refresh) {
      if (_currentPage != 1 || _currentSearch != null) {
        filtersChanged = true;
      }
      _currentPage = 1;
      _currentSearch = null;
    } else {
      if (pageNumber != null && pageNumber > 0 && pageNumber != _currentPage) {
        _currentPage = pageNumber;
        filtersChanged = true;
      }
      if (search != null) {
        final newSearch = search.trim().isEmpty ? null : search.trim();
        if (_currentSearch != newSearch) {
          _currentSearch = newSearch;
          _currentPage = 1;
          filtersChanged = true;
        }
      }
    }

    _branchesSubscription?.cancel();

    if (state is! BranchesListSuccess || filtersChanged) {
      emit(BranchesListLoading());
    }

    _branchesSubscription =
        getBranchesUseCase(
          pageNumber: _currentPage,
          pageSize: _pageSize,
          search: _currentSearch,
        ).listen((result) {
          result.fold(
            (failure) {
              if (isClosed) return;
              if (state is! BranchesListSuccess) {
                emit(BranchesListFailure(failure.message));
              }
            },
            (entity) {
              if (isClosed) return;
              if (_currentPage == 1) {
                _accumulatedItems = List.from(entity.data);
              } else {
                _accumulatedItems.addAll(entity.data);
              }
              emit(
                BranchesListSuccess(
                  response: entity,
                  items: List.from(_accumulatedItems),
                  isFetchingMore: false,
                  hasReachedMax: _currentPage >= entity.totalPages || entity.data.isEmpty,
                ),
              );
            },
          );
        });
  }

  Future<void> loadMore() async {
    if (_isFetchingMore) return;
    if (state is! BranchesListSuccess) return;

    final currentState = state as BranchesListSuccess;
    if (currentState.hasReachedMax) return;

    _isFetchingMore = true;
    _currentPage++;
    emit(currentState.copyWith(isFetchingMore: true));

    _branchesSubscription?.cancel();
    _branchesSubscription =
        getBranchesUseCase(
          pageNumber: _currentPage,
          pageSize: _pageSize,
          search: _currentSearch,
        ).listen((result) {
          _isFetchingMore = false;
          result.fold(
            (failure) {
              if (isClosed) return;
              _currentPage--;
              emit(currentState.copyWith(isFetchingMore: false));
            },
            (entity) {
              if (isClosed) return;
              _accumulatedItems.addAll(entity.data);
              emit(
                BranchesListSuccess(
                  response: entity,
                  items: List.from(_accumulatedItems),
                  isFetchingMore: false,
                  hasReachedMax: _currentPage >= entity.totalPages || entity.data.isEmpty,
                ),
              );
            },
          );
        });
  }

  @override
  Future<void> close() {
    _branchesSubscription?.cancel();
    return super.close();
  }
}
