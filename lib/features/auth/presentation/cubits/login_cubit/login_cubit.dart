import 'package:bloc/bloc.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/auth/data/model/login_response.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import '/core/di/services_locator.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.networkService) : super(LoginInitial());

  final NetworkService networkService;

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    showLoading();

    final response = await networkService.postData(
      endPoint: EndPoints.login,
      data: {'email': email, 'password': password},
    );

    showLoading();

    response.fold(
      (failure) {
        showError(failure.message);
        emit(LoginFailure(failure.message));
      },
      (data) async {
        final loginResponse = LoginResponse.fromJson(data);
        await saveUserToken(loginResponse.accessToken);
        emit(LoginSuccess(loginResponse));
      },
    );
  }

  Future<void> saveUserToken(String token) async {
    await sl<PreferencesStorage>().saveUserToken(token);
  }
}
