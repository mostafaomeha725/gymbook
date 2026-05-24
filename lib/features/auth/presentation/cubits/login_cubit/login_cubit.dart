import 'package:bloc/bloc.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/auth/domain/entities/login_result_entity.dart';
import 'package:gymbook/features/auth/domain/usecases/login_usecase.dart';
import 'package:gymbook/features/auth/domain/usecases/login_with_google_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginUseCase, required this.loginWithGoogleUseCase})
    : super(LoginInitial());

  final LoginUseCase loginUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;

  // ─── Email / Password Login ────────────────────────────────────────────────

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    showLoading();

    final result = await loginUseCase(email: email, password: password);

    hideLoading();

    result.fold((failure) {
      showError(failure.message);
      emit(LoginFailure(failure.message));
    }, (loginResult) => emit(LoginSuccess(loginResult)));
  }

  // ─── Google Login ──────────────────────────────────────────────────────────

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    showLoading();

    final result = await loginWithGoogleUseCase();

    hideLoading();

    result.fold((failure) {
      if (failure is UserCancelledFailure) {
        showInfo('Google sign-in was cancelled.');
        emit(LoginInitial());
        return;
      }
      showError(failure.message);
      emit(LoginFailure(failure.message));
    }, (loginResult) => emit(LoginSuccess(loginResult)));
  }
}
