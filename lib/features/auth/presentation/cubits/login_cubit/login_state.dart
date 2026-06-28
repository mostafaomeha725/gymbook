part of 'login_cubit.dart';

sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final LoginResultEntity loginResult;
  const LoginSuccess(this.loginResult);
}

final class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
}

final class LoginEmailNotVerified extends LoginState {
  const LoginEmailNotVerified();
}
