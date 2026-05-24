import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/review_entity.dart';

part 'branch_reviews_state.dart';

class BranchReviewsCubit extends Cubit<BranchReviewsState> {
  BranchReviewsCubit() : super(BranchReviewsInitial());

  List<ReviewEntity> _allReviews = [];
  String _selectedRating = 'All';
  int _currentPage = 1;
  final int _totalPages = 2; // For mock

  void loadReviews(int branchId) {
    emit(BranchReviewsLoading());

    // Mock data based on the design
    _allReviews = [
      const ReviewEntity(
        id: '1',
        authorName: 'Ahmed Mohamed',
        content:
            'Excellent gym with modern equipment and very clean facilities. The staff is professional and helpful.',
        rating: 5.0,
        timeAgo: '2 days ago',
        initials: 'AM',
      ),
      const ReviewEntity(
        id: '2',
        authorName: 'Sara Ali',
        content:
            'Great gym overall. Only suggestion is to add more cardio machines during peak hours.',
        rating: 4.0,
        timeAgo: '5 days ago',
        initials: 'SA',
      ),
      const ReviewEntity(
        id: '3',
        authorName: 'Omar Hassan',
        content:
            'Best gym in the area! Love the variety of equipment and the atmosphere is very motivating.',
        rating: 5.0,
        timeAgo: '1 week ago',
        initials: 'OH',
      ),
      const ReviewEntity(
        id: '4',
        authorName: 'Khaled Samir',
        content:
            'Good gym but can get very crowded during evening hours. Otherwise, no major complaints.',
        rating: 3.0,
        timeAgo: '2 weeks ago',
        initials: 'KS',
      ),
    ];

    _emitLoaded();
  }

  void filterByRating(String rating) {
    _selectedRating = rating;
    _emitLoaded();
  }

  void changePage(int page) {
    _currentPage = page;
    _emitLoaded();
  }

  void _emitLoaded() {
    List<ReviewEntity> filtered = _allReviews;
    if (_selectedRating != 'All') {
      final ratingValue = double.tryParse(_selectedRating);
      if (ratingValue != null) {
        filtered = _allReviews.where((r) => r.rating == ratingValue).toList();
      }
    }

    emit(
      BranchReviewsLoaded(
        reviews: filtered,
        selectedRating: _selectedRating,
        currentPage: _currentPage,
        totalPages: _totalPages,
        averageRating: 4.3,
        totalCount: 7,
      ),
    );
  }
}
