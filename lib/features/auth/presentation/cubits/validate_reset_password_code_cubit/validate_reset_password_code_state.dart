part of 'validate_reset_password_code_cubit.dart';

sealed class ValidateResetPasswordCodeState {
  const ValidateResetPasswordCodeState();
}

final class ValidateResetPasswordCodeInitial
    extends ValidateResetPasswordCodeState {}

final class ValidateResetPasswordCodeLoading
    extends ValidateResetPasswordCodeState {}

final class ValidateResetPasswordCodeSuccess
    extends ValidateResetPasswordCodeState {}

final class ValidateResetPasswordCodeInvalid
    extends ValidateResetPasswordCodeState {
  final String message;

  const ValidateResetPasswordCodeInvalid(this.message);
}

final class ValidateResetPasswordCodeFailure
    extends ValidateResetPasswordCodeState {
  final String message;

  const ValidateResetPasswordCodeFailure(this.message);
}
