import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/auth/domain/usecases/resend_confirmation_email_usecase.dart';

part 'resend_confirmation_email_state.dart';

class ResendConfirmationEmailCubit extends Cubit<ResendConfirmationEmailState> {
  ResendConfirmationEmailCubit(this.resendConfirmationEmailUseCase)
    : super(ResendConfirmationEmailInitial());

  final ResendConfirmationEmailUseCase resendConfirmationEmailUseCase;

  Future<void> resendConfirmationEmail(String email) async {
    emit(ResendConfirmationEmailLoading());
    showLoading();

    final result = await resendConfirmationEmailUseCase(email: email);

    hideLoading();

    result.fold(
      (failure) {
        showError(failure.message);
        emit(ResendConfirmationEmailFailure(failure.message));
      },
      (_) {
        showSuccess('A new verification code has been sent.');
        emit(ResendConfirmationEmailSuccess());
      },
    );
  }
}
