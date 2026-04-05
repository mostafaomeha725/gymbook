import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/auth/domain/usecases/reset_password_usecase.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this.resetPasswordUseCase) : super(ResetPasswordInitial());

  final ResetPasswordUseCase resetPasswordUseCase;

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    emit(ResetPasswordLoading());
    showLoading();

    final result = await resetPasswordUseCase(
      email: email,
      code: code,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );

    hideLoading();

    result.fold(
      (failure) {
        showError(failure.message);
        emit(ResetPasswordFailure(failure.message));
      },
      (_) {
        showSuccess('Password reset successfully.');
        emit(ResetPasswordSuccess());
      },
    );
  }
}
