part of 'reset_password_cubit.dart';

sealed class ResetPasswordState {
  const ResetPasswordState();
}

final class ResetPasswordInitial extends ResetPasswordState {}

final class ResetPasswordLoading extends ResetPasswordState {}

final class ResetPasswordSuccess extends ResetPasswordState {}

final class ResetPasswordFailure extends ResetPasswordState {
  final String message;

  const ResetPasswordFailure(this.message);
}
