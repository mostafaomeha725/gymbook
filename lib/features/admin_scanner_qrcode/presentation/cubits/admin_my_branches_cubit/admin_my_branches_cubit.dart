import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin_scanner_qrcode/domain/entities/admin_branch_option_entity.dart';
import 'package:gymbook/features/admin_scanner_qrcode/domain/usecases/get_admin_my_branches_usecase.dart';

part 'admin_my_branches_state.dart';

class AdminMyBranchesCubit extends Cubit<AdminMyBranchesState> {
  AdminMyBranchesCubit(this.getAdminMyBranchesUseCase)
    : super(AdminMyBranchesInitial());

  final GetAdminMyBranchesUseCase getAdminMyBranchesUseCase;

  Future<void> loadBranches() async {
    if (state is AdminMyBranchesLoading) return;

    emit(AdminMyBranchesLoading());

    final result = await getAdminMyBranchesUseCase();

    result.fold(
      (failure) => emit(AdminMyBranchesFailure(failure.message)),
      (branches) => emit(AdminMyBranchesSuccess(branches)),
    );
  }
}
