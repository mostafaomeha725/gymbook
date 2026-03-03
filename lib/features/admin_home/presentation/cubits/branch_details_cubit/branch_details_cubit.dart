import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/data/models/branch_details_model.dart';
import 'package:gymbook/features/admin_home/data/repositories/admin_branch_repository.dart';

part 'branch_details_state.dart';

class BranchDetailsCubit extends Cubit<BranchDetailsState> {
  BranchDetailsCubit(this.repository) : super(BranchDetailsInitial());

  final AdminBranchRepository repository;

  Future<void> loadBranchDetails(int branchId) async {
    emit(BranchDetailsLoading());
    showLoading();

    final result = await repository.getBranchDetails(branchId);

    hideLoading();

    result.fold(
      (failure) => emit(BranchDetailsFailure(failure)),
      (response) => emit(BranchDetailsSuccess(response)),
    );
  }
}
