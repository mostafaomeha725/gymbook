import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/package_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_packages_usecase.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_packages_list_cubit/branch_packages_list_state.dart';

class BranchPackagesListCubit extends Cubit<BranchPackagesListState> {
  BranchPackagesListCubit(this.getBranchPackagesUseCase)
    : super(BranchPackagesListInitial());

  final GetBranchPackagesUseCase getBranchPackagesUseCase;
  StreamSubscription? _subscription;

  int _currentPage = 1;
  static const int _pageSize = 5;
  bool _isFetchingMore = false;
  List<PackageEntity> _accumulatedItems = [];
  late int _currentBranchId;

  Future<void> loadPackages({
    required int branchId,
    bool refresh = false,
  }) async {
    _currentBranchId = branchId;
    if (refresh) {
      _currentPage = 1;
      _accumulatedItems.clear();
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
              if (isClosed) return;
              if (state is! BranchPackagesListSuccess) {
                emit(BranchPackagesListFailure(failure.message));
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
                BranchPackagesListSuccess(
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
    if (state is! BranchPackagesListSuccess) return;

    final currentState = state as BranchPackagesListSuccess;
    if (currentState.hasReachedMax) return;

    _isFetchingMore = true;
    _currentPage++;
    emit(currentState.copyWith(isFetchingMore: true));

    _subscription?.cancel();
    _subscription =
        getBranchPackagesUseCase(
          branchId: _currentBranchId,
          pageNumber: _currentPage,
          pageSize: _pageSize,
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
                BranchPackagesListSuccess(
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
    _subscription?.cancel();
    return super.close();
  }
}
