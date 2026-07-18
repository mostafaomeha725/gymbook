import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/review_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_reviews_usecase.dart';

part 'branch_reviews_state.dart';

class BranchReviewsCubit extends Cubit<BranchReviewsState> {
  final GetBranchReviewsUseCase _getBranchReviewsUseCase;

  BranchReviewsCubit(this._getBranchReviewsUseCase)
    : super(BranchReviewsInitial());

  bool _isFetchingMore = false;
  List<ReviewEntity> _allReviews = [];
  String _selectedRating = 'All';
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  double _averageRating = 0.0;
  bool _canReview = false;
  ReviewEntity? _myReview;
  late int _currentBranchId;

  Future<void> loadReviews(int branchId, {bool isRefresh = false}) async {
    _currentBranchId = branchId;
    if (isRefresh || _currentPage == 1) {
      _allReviews.clear();
      _currentPage = 1;
    }

    if (state is! BranchReviewsLoaded) {
      emit(BranchReviewsLoading());
    }

    double? ratingFilter;
    if (_selectedRating != 'All') {
      ratingFilter = double.tryParse(_selectedRating);
    }

    final result = await _getBranchReviewsUseCase(
      branchId: branchId,
      pageNumber: _currentPage,
      pageSize: 5,
      rating: ratingFilter,
    );

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(BranchReviewsError(failure.message));
      },
      (entity) {
        if (isClosed) return;
        if (_currentPage == 1) {
          _allReviews = List.from(entity.data);
        } else {
          _allReviews.addAll(entity.data);
        }

        _totalPages = entity.totalPages;
        _canReview = entity.canReview;
        _myReview = entity.myReview;

        final allItems = [if (_myReview != null) _myReview!, ..._allReviews];

        // The API already includes myReview in the total count
        _totalCount = entity.totalCount;

        if (allItems.isNotEmpty) {
          _averageRating =
              allItems.map((e) => e.rating).reduce((a, b) => a + b) /
              allItems.length;
        } else {
          _averageRating = 0.0;
        }

        _emitLoaded(isLastPage: entity.data.isEmpty);
      },
    );
  }

  void filterByRating(String rating) {
    _selectedRating = rating;
    _currentPage = 1;
    loadReviews(_currentBranchId);
  }

  Future<void> loadMore() async {
    if (_isFetchingMore) return;
    if (state is! BranchReviewsLoaded) return;

    final currentState = state as BranchReviewsLoaded;
    if (currentState.hasReachedMax) return;

    _isFetchingMore = true;
    _currentPage++;
    emit(currentState.copyWith(isFetchingMore: true));

    double? ratingFilter;
    if (_selectedRating != 'All') {
      ratingFilter = double.tryParse(_selectedRating);
    }

    final result = await _getBranchReviewsUseCase(
      branchId: _currentBranchId,
      pageNumber: _currentPage,
      pageSize: 5,
      rating: ratingFilter,
    );

    _isFetchingMore = false;
    result.fold(
      (failure) {
        if (isClosed) return;
        _currentPage--;
        emit(currentState.copyWith(isFetchingMore: false));
      },
      (entity) {
        if (isClosed) return;
        _allReviews.addAll(entity.data);
        _totalPages = entity.totalPages;
        _canReview = entity.canReview;
        _myReview = entity.myReview;
        _totalCount = entity.totalCount;

        final allItems = [if (_myReview != null) _myReview!, ..._allReviews];
        if (allItems.isNotEmpty) {
          _averageRating =
              allItems.map((e) => e.rating).reduce((a, b) => a + b) /
              allItems.length;
        } else {
          _averageRating = 0.0;
        }
        _emitLoaded(isLastPage: entity.data.isEmpty);
      },
    );
  }

  void _emitLoaded({bool isLastPage = false}) {
    emit(
      BranchReviewsLoaded(
        reviews: _allReviews,
        selectedRating: _selectedRating,
        currentPage: _currentPage,
        totalPages: _totalPages,
        averageRating: double.parse(_averageRating.toStringAsFixed(1)),
        totalCount: _totalCount,
        canReview: _canReview,
        myReview: _myReview,
        isFetchingMore: false,
        hasReachedMax: _currentPage >= _totalPages || isLastPage,
      ),
    );
  }
}
