import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/data/models/create_branch_model.dart';
import 'package:gymbook/features/admin_home/data/repositories/admin_branch_repository.dart';

part 'create_branch_state.dart';

class CreateBranchCubit extends Cubit<CreateBranchState> {
  CreateBranchCubit(this.repository) : super(CreateBranchInitial());

  final AdminBranchRepository repository;

  Future<void> createBranch({
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) async {
    emit(CreateBranchLoading());
    showLoading();

    final response = await repository.createBranch(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      branchType: branchType,
    );

    hideLoading();

    response.fold(
      (failure) {
        showError(failure);
        emit(CreateBranchFailure(failure));
      },
      (branchResponse) {
        // Create response with all original data for state
        final successResponse = CreateBranchResponse(
          id: branchResponse.id,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          branchType: branchType,
        );
        emit(CreateBranchSuccess(successResponse));
      },
    );
  }

  Future<void> editBranch({
    required int branchId,
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) async {
    emit(CreateBranchLoading());
    showLoading();

    final response = await repository.updateBranchDetails(
      branchId: branchId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      branchType: branchType,
    );

    hideLoading();

    response.fold(
      (failure) {
        showError(failure);
        emit(CreateBranchFailure(failure));
      },
      (_) {
        emit(
          CreateBranchSuccess(
            CreateBranchResponse(
              id: branchId,
              name: name,
              email: email,
              phoneNumber: phoneNumber,
              branchType: branchType,
            ),
          ),
        );
      },
    );
  }
}
