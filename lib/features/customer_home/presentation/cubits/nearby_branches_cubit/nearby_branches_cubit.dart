import 'package:bloc/bloc.dart';
import 'package:gymbook/features/customer_home/domain/entities/nearby_branches_page_entity.dart';
import 'package:gymbook/features/customer_home/domain/usecases/get_nearby_branches_usecase.dart';

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

  int get currentPage => _currentPage;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  Future<void> setLocation({
    required double latitude,
    required double longitude,
  }) async {
    _latitude = latitude;
    _longitude = longitude;
    _currentPage = 1;
    await loadNearby();
  }

  Future<void> loadNearby({
    int? pageNumber,
    String? search,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _currentSearch = null;
    } else {
      if (pageNumber != null && pageNumber > 0) {
        _currentPage = pageNumber;
      }
      if (search != null) {
        _currentSearch = search.trim().isEmpty ? null : search.trim();
        _currentPage = 1;
      }
    }

    emit(NearbyBranchesLoading());

    final result = await getNearbyBranchesUseCase(
      latitude: _latitude,
      longitude: _longitude,
      radiusInMeters: _radiusInMeters,
      pageNumber: _currentPage,
      pageSize: _pageSize,
      search: _currentSearch,
    );

    result.fold(
      (failure) => emit(NearbyBranchesFailure(failure.message)),
      (response) => emit(NearbyBranchesSuccess(response)),
    );
  }
}
