import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/domain/entities/branch_details_entity.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branch_details_usecase.dart';

part 'branch_details_state.dart';

class BranchDetailsCubit extends Cubit<BranchDetailsState> {
  BranchDetailsCubit(this.getBranchDetailsUseCase)
    : super(BranchDetailsInitial());

  final GetBranchDetailsUseCase getBranchDetailsUseCase;

  Future<void> loadBranchDetails(int branchId) async {
    emit(BranchDetailsLoading());
    showLoading();

    final result = await getBranchDetailsUseCase(branchId);

    hideLoading();

    result.fold(
      (failure) => emit(BranchDetailsFailure(failure.message)),
      (entity) => emit(BranchDetailsSuccess(entity)),
    );
  }
}
