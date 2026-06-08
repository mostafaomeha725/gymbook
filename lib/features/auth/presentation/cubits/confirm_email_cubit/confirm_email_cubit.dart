import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/auth/domain/usecases/confirm_email_usecase.dart';
import 'package:gymbook/features/auth/presentation/cubits/confirm_email_cubit/confirm_email_state.dart';

class ConfirmEmailCubit extends Cubit<ConfirmEmailState> {
  final ConfirmEmailUseCase confirmEmailUseCase;

  ConfirmEmailCubit(this.confirmEmailUseCase) : super(ConfirmEmailInitial());

  Future<void> confirmEmail({
    required String email,
    required String code,
  }) async {
    emit(ConfirmEmailLoading());

    final result = await confirmEmailUseCase.call(email: email, code: code);

    result.fold(
      (failure) => emit(ConfirmEmailFailure(message: failure.message)),
      (_) => emit(ConfirmEmailSuccess()),
    );
  }
}
