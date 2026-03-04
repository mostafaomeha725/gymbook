import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/domain/entities/created_branch_entity.dart';
import 'package:gymbook/features/admin_home/domain/usecases/create_branch_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/edit_branch_usecase.dart';

part 'create_branch_state.dart';

class CreateBranchCubit extends Cubit<CreateBranchState> {
  CreateBranchCubit({
    required this.createBranchUseCase,
    required this.editBranchUseCase,
  }) : super(CreateBranchInitial());

  final CreateBranchUseCase createBranchUseCase;
  final EditBranchUseCase editBranchUseCase;

  Future<void> createBranch({
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) async {
    emit(CreateBranchLoading());
    showLoading();

    final result = await createBranchUseCase(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      branchType: branchType,
    );

    hideLoading();

    result.fold(
      (failure) {
        showError(failure.message);
        emit(CreateBranchFailure(failure.message));
      },
      (entity) {
        emit(
          CreateBranchSuccess(
            CreatedBranchEntity(
              id: entity.id,
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

  Future<void> editBranch({
    required int branchId,
    required String name,
    required String email,
    required String phoneNumber,
    required int branchType,
  }) async {
    emit(CreateBranchLoading());
    showLoading();

    final result = await editBranchUseCase(
      branchId: branchId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      branchType: branchType,
    );

    hideLoading();

    result.fold(
      (failure) {
        showError(failure.message);
        emit(CreateBranchFailure(failure.message));
      },
      (_) {
        emit(
          CreateBranchSuccess(
            CreatedBranchEntity(
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
