part of 'register_cubit.dart';

sealed class RegisterState {
  const RegisterState();
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final UserEntity user;
  const RegisterSuccess(this.user);
}

final class RegisterFailure extends RegisterState {
  final String message;
  const RegisterFailure(this.message);
}
