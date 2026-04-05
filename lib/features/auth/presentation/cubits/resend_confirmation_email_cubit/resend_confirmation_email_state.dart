part of 'resend_confirmation_email_cubit.dart';

sealed class ResendConfirmationEmailState {
  const ResendConfirmationEmailState();
}

final class ResendConfirmationEmailInitial
    extends ResendConfirmationEmailState {}

final class ResendConfirmationEmailLoading
    extends ResendConfirmationEmailState {}

final class ResendConfirmationEmailSuccess
    extends ResendConfirmationEmailState {}

final class ResendConfirmationEmailFailure
    extends ResendConfirmationEmailState {
  final String message;

  const ResendConfirmationEmailFailure(this.message);
}
