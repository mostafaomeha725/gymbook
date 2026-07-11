import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/review_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_reviews_usecase.dart';

part 'branch_reviews_state.dart';

class BranchReviewsCubit extends Cubit<BranchReviewsState> {
  final GetBranchReviewsUseCase _getBranchReviewsUseCase;

  BranchReviewsCubit(this._getBranchReviewsUseCase)
    : super(BranchReviewsInitial());

  List<ReviewEntity> _allReviews = [];
  String _selectedRating = 'All';
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  double _averageRating = 0.0;
  bool _canReview = false;
  ReviewEntity? _myReview;
  late int _currentBranchId;

  Future<void> loadReviews(int branchId, {bool isLoadMore = false}) async {
    _currentBranchId = branchId;
    if (!isLoadMore) {
      emit(BranchReviewsLoading());
      _currentPage = 1;
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
        emit(BranchReviewsError(failure.message));
      },
      (entity) {
        if (!isLoadMore) {
          _allReviews = entity.data;
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

        _emitLoaded();
      },
    );
  }

  void filterByRating(String rating) {
    _selectedRating = rating;
    loadReviews(_currentBranchId, isLoadMore: false);
  }

  void changePage(int page) {
    _currentPage = page;
    loadReviews(
      _currentBranchId,
      isLoadMore: false,
    ); // According to UI, might need full reload on page change, not append
  }

  void _emitLoaded() {
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
      ),
    );
  }
}
