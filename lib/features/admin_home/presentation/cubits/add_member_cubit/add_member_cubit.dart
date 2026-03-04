import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/domain/entities/add_member_entity.dart';
import 'package:gymbook/features/admin_home/domain/usecases/add_member_usecase.dart';

part 'add_member_state.dart';

class AddMemberCubit extends Cubit<AddMemberState> {
  AddMemberCubit(this.addMemberUseCase) : super(AddMemberInitial());

  final AddMemberUseCase addMemberUseCase;

  Future<void> addMember({
    required int branchId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required int packageId,
  }) async {
    if (firstName.trim().isEmpty) {
      showError("First name can't be empty");
      emit(AddMemberFailure("First name can't be empty"));
      return;
    }
    if (lastName.trim().isEmpty) {
      showError("Last name can't be empty");
      emit(AddMemberFailure("Last name can't be empty"));
      return;
    }
    if (phoneNumber.trim().isEmpty) {
      showError("Phone number can't be empty");
      emit(AddMemberFailure("Phone number can't be empty"));
      return;
    }
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      showError("Email can't be empty");
      emit(AddMemberFailure("Email can't be empty"));
      return;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(trimmedEmail)) {
      showError('Please enter a valid email address');
      emit(AddMemberFailure('Please enter a valid email address'));
      return;
    }

    emit(AddMemberLoading());
    showLoading();

    final result = await addMemberUseCase(
      branchId: branchId,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      phoneNumber: phoneNumber.trim(),
      email: trimmedEmail,
      packageId: packageId,
    );

    hideLoading();

    result.fold(
      (failure) {
        showError(failure.message);
        emit(AddMemberFailure(failure.message));
      },
      (entity) {
        showSuccess('Member added successfully');
        emit(AddMemberSuccess(entity));
      },
    );
  }
}
