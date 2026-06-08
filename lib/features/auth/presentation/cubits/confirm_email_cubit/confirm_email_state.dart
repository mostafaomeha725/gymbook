abstract class ConfirmEmailState {
  const ConfirmEmailState();
}

class ConfirmEmailInitial extends ConfirmEmailState {}

class ConfirmEmailLoading extends ConfirmEmailState {}

class ConfirmEmailSuccess extends ConfirmEmailState {}

class ConfirmEmailFailure extends ConfirmEmailState {
  final String message;

  const ConfirmEmailFailure({required this.message});
}
