import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gymbook/features/customer/customer_home/domain/entities/nearby_branch_entity.dart';
import 'package:gymbook/features/customer/customer_home/domain/entities/nearby_branches_page_entity.dart';
import 'package:gymbook/features/customer/customer_home/domain/usecases/get_nearby_branches_usecase.dart';

part 'nearby_branches_state.dart';

class NearbyBranchesCubit extends Cubit<NearbyBranchesState> {
  NearbyBranchesCubit(this.getNearbyBranchesUseCase)
    : super(NearbyBranchesInitial());

  final GetNearbyBranchesUseCase getNearbyBranchesUseCase;

  static const int _pageSize = 5;
  static const int _radiusInMeters = 15000;

  int _currentPage = 1;
  String? _currentSearch;
  double? _latitude;
  double? _longitude;

  bool _isFetchingMore = false;
  List<NearbyBranchEntity> _accumulatedBranches = [];

  StreamSubscription? _subscription;

  int get currentPage => _currentPage;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  Future<void> setLocation({
    required double latitude,
    required double longitude,
  }) async {
    if (_latitude != latitude || _longitude != longitude) {
      _latitude = latitude;
      _longitude = longitude;
      _currentPage = 1;
      _accumulatedBranches.clear();
      emit(NearbyBranchesLoading());
    }
    await loadNearby();
  }

  Future<void> clearLocation() async {
    if (_latitude != null || _longitude != null) {
      _latitude = null;
      _longitude = null;
      _currentPage = 1;
      _accumulatedBranches.clear();
      emit(NearbyBranchesLoading());
    }
    await loadNearby();
  }

  Future<void> loadMore() async {
    if (_isFetchingMore) return;
    if (state is! NearbyBranchesSuccess) return;

    final currentState = state as NearbyBranchesSuccess;
    if (currentState.hasReachedMax) return;

    _isFetchingMore = true;
    _currentPage++;
    emit(currentState.copyWith(isFetchingMore: true));

    _subscription?.cancel();

    _subscription =
        getNearbyBranchesUseCase(
          latitude: _latitude,
          longitude: _longitude,
          radiusInMeters: _radiusInMeters,
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
            (response) {
              _accumulatedBranches.addAll(response.data);
              emit(
                NearbyBranchesSuccess(
                  response: response,
                  branches: List.from(_accumulatedBranches),
                  isFetchingMore: false,
                  hasReachedMax: _currentPage >= response.totalPages || response.data.isEmpty,
                ),
              );
            },
          );
        });
  }

  Future<void> loadNearby({
    int? pageNumber,
    String? search,
    bool refresh = false,
  }) async {
    bool filtersChanged = false;

    if (refresh) {
      if (_currentPage != 1 || _currentSearch != null) {
        filtersChanged = true;
      }
      _currentPage = 1;
      _currentSearch = null;
      _accumulatedBranches.clear();
    } else {
      if (pageNumber != null && pageNumber > 0 && pageNumber != _currentPage) {
        _currentPage = pageNumber;
        filtersChanged = true;
        _accumulatedBranches.clear();
      }
      if (search != null) {
        final newSearch = search.trim().isEmpty ? null : search.trim();
        if (_currentSearch != newSearch) {
          _currentSearch = newSearch;
          _currentPage = 1;
          _accumulatedBranches.clear();
          filtersChanged = true;
        }
      }
    }

    await _subscription?.cancel();

    if (state is! NearbyBranchesSuccess || filtersChanged) {
      emit(NearbyBranchesLoading());
    }

    _subscription =
        getNearbyBranchesUseCase(
          latitude: _latitude,
          longitude: _longitude,
          radiusInMeters: _radiusInMeters,
          pageNumber: _currentPage,
          pageSize: _pageSize,
          search: _currentSearch,
        ).listen((result) {
          result.fold(
            (failure) {
              if (isClosed) return;
              if (state is! NearbyBranchesSuccess) {
                emit(NearbyBranchesFailure(failure.message));
              }
            },
            (response) {
              if (isClosed) return;
              if (_currentPage == 1) {
                _accumulatedBranches = List.from(response.data);
              } else {
                _accumulatedBranches.addAll(response.data);
              }
              emit(
                NearbyBranchesSuccess(
                  response: response,
                  branches: List.from(_accumulatedBranches),
                  isFetchingMore: false,
                  hasReachedMax: _currentPage >= response.totalPages || response.data.isEmpty,
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
