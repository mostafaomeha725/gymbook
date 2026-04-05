part of 'forget_password_cubit.dart';

sealed class ForgetPasswordState {
  const ForgetPasswordState();
}

final class ForgetPasswordInitial extends ForgetPasswordState {}

final class ForgetPasswordLoading extends ForgetPasswordState {}

final class ForgetPasswordSuccess extends ForgetPasswordState {}

final class ForgetPasswordFailure extends ForgetPasswordState {
  final String message;

  const ForgetPasswordFailure(this.message);
}
