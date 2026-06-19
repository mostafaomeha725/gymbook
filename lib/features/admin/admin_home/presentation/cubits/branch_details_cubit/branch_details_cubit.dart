import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_details_usecase.dart';

part 'branch_details_state.dart';

class BranchDetailsCubit extends Cubit<BranchDetailsState> {
  BranchDetailsCubit(this.getBranchDetailsUseCase)
    : super(BranchDetailsInitial());

  final GetBranchDetailsUseCase getBranchDetailsUseCase;
  StreamSubscription? _subscription;

  Future<void> loadBranchDetails(int branchId) async {
    _subscription?.cancel();

    if (state is! BranchDetailsSuccess) {
      emit(BranchDetailsLoading());
    }

    _subscription = getBranchDetailsUseCase(branchId).listen((result) {
      result.fold((failure) {
        if (state is! BranchDetailsSuccess) {
          emit(BranchDetailsFailure(failure.message));
        }
      }, (entity) => emit(BranchDetailsSuccess(entity)));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
