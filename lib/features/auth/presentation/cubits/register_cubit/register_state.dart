part of 'register_cubit.dart';

@immutable
sealed class RegisterState {
  const RegisterState();
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final String message;
  final String phoneNumber;
  final String countryCode;

  const RegisterSuccess(this.message, this.phoneNumber, this.countryCode);
}

final class RegisterFailure extends RegisterState {
  final String message;
  const RegisterFailure(this.message);
}
