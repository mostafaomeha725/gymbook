import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:gymbook/features/auth/presentation/cubits/change_password_cubit/change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordCubit({required this.changePasswordUseCase})
      : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    emit(ChangePasswordLoading());
    final result = await changePasswordUseCase(
      ChangePasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      ),
    );

    result.fold(
      (failure) => emit(ChangePasswordFailure(message: failure.message)),
      (_) => emit(ChangePasswordSuccess()),
    );
  }
}
