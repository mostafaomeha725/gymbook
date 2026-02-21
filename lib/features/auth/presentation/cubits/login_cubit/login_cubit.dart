import 'package:bloc/bloc.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/core/services/google_sign_in_service.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/auth/data/model/login_response.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import '/core/di/services_locator.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.networkService) : super(LoginInitial());

  final NetworkService networkService;

  // ─── Email / Password Login ────────────────────────────────────────────────

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    showLoading();

    final response = await networkService.postData(
      endPoint: EndPoints.login,
      data: {'email': email, 'password': password},
    );

    hideLoading();

    response.fold(
      (failure) {
        showError(failure.message);
        emit(LoginFailure(failure.message));
      },
      (data) async {
        final loginResponse = LoginResponse.fromJson(data);
        await _saveSession(loginResponse);
        emit(LoginSuccess(loginResponse));
      },
    );
  }

  // ─── Google Login ──────────────────────────────────────────────────────────

  Future<void> loginWithGoogle() async {
    final idToken = await GoogleSignInService.getIdToken();

    if (idToken == null) return; // user cancelled

    emit(LoginLoading());
    showLoading();

    final response = await networkService.postData(
      endPoint: EndPoints.googleLogin,
      data: {'idToken': idToken},
    );

    hideLoading();

    response.fold(
      (failure) {
        showError(failure.message);
        emit(LoginFailure(failure.message));
      },
      (data) async {
        final loginResponse = LoginResponse.fromJson(data);
        await _saveSession(loginResponse);
        emit(LoginSuccess(loginResponse));
      },
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _saveSession(LoginResponse response) async {
    await sl<PreferencesStorage>().saveUserToken(response.accessToken);
  }
}
