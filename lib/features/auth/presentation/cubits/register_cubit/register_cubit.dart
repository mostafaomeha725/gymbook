import 'package:bloc/bloc.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/auth/data/model/register_response.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.networkService) : super(RegisterInitial());

  final NetworkService networkService;

  Future<void> register({
    required String fullName,
    required String email,
    required String countryCode,
    required String phoneNumber,
    required String password,
  }) async {
    showLoading();

    final response = await networkService.postData(
      endPoint: EndPoints.register,
      data: {
        'full_name': fullName,
        'email': email,
        'country_code': '+$countryCode',
        'phone_number': phoneNumber,
        'password': password,
      },
    );

    hideLoading();

    response.fold(
      (failure) {
        showError(failure.message);
        emit(RegisterFailure(failure.message));
      },
      (response) {
        final registerResponse = RegisterResponse.fromJson(response);
        if (registerResponse.success) {
          emit(
            RegisterSuccess(registerResponse.message, phoneNumber, countryCode),
          );
        } else {
          showError(registerResponse.message);
          emit(RegisterFailure(registerResponse.message));
        }
      },
    );
  }
}
