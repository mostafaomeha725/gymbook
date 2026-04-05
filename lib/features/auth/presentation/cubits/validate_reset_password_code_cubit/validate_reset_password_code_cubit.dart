import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/auth/domain/usecases/validate_reset_password_code_usecase.dart';

part 'validate_reset_password_code_state.dart';

class ValidateResetPasswordCodeCubit
    extends Cubit<ValidateResetPasswordCodeState> {
  ValidateResetPasswordCodeCubit(this.validateResetPasswordCodeUseCase)
    : super(ValidateResetPasswordCodeInitial());

  final ValidateResetPasswordCodeUseCase validateResetPasswordCodeUseCase;

  Future<void> validateResetPasswordCode({
    required String email,
    required String code,
  }) async {
    emit(ValidateResetPasswordCodeLoading());
    showLoading();

    final result = await validateResetPasswordCodeUseCase(
      email: email,
      code: code,
    );

    hideLoading();

    result.fold(
      (failure) {
        showError(failure.message);
        emit(ValidateResetPasswordCodeFailure(failure.message));
      },
      (isValid) {
        if (!isValid) {
          const message = 'Invalid reset code. Please try again.';
          showError(message);
          emit(const ValidateResetPasswordCodeInvalid(message));
          return;
        }

        emit(ValidateResetPasswordCodeSuccess());
      },
    );
  }
}
