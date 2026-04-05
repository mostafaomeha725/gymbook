import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/auth/domain/usecases/send_reset_password_email_usecase.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this.sendResetPasswordEmailUseCase)
    : super(ForgetPasswordInitial());

  final SendResetPasswordEmailUseCase sendResetPasswordEmailUseCase;

  Future<void> sendResetPasswordEmail(String email) async {
    emit(ForgetPasswordLoading());
    showLoading();

    final result = await sendResetPasswordEmailUseCase(email: email);

    hideLoading();

    result.fold(
      (failure) {
        showError(failure.message);
        emit(ForgetPasswordFailure(failure.message));
      },
      (_) {
        showSuccess('Reset code sent to your email.');
        emit(ForgetPasswordSuccess());
      },
    );
  }
}
