import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin_home/data/repositories/admin_branch_repository.dart';

part 'branches_list_state.dart';

class BranchesListCubit extends Cubit<BranchesListState> {
  BranchesListCubit(this.repository) : super(BranchesListInitial());

  final AdminBranchRepository repository;

  int _currentPage = 1;
  static const int _pageSize = 3;

  Future<void> loadBranches({bool refresh = false, int? pageNumber}) async {
    if (refresh) {
      _currentPage = 1;
    } else if (pageNumber != null && pageNumber > 0) {
      _currentPage = pageNumber;
    }

    emit(BranchesListLoading());

    final result = await repository.getBranches(
      pageNumber: _currentPage,
      pageSize: _pageSize,
    );

    result.fold(
      (failure) => emit(BranchesListFailure(failure)),
      (response) => emit(BranchesListSuccess(response)),
    );
  }
}
