import 'package:bloc/bloc.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/auth/data/model/register_response.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.networkService) : super(RegisterInitial());

  final NetworkService networkService;

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    bool isOwner = false,
  }) async {
    emit(RegisterLoading());
    showLoading();

    final response = await networkService.postData(
      endPoint: isOwner ? EndPoints.registerOwner : EndPoints.registerUser,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'phoneNumber': phoneNumber,
      },
    );

    hideLoading();

    response.fold(
      (failure) {
        showError(failure.message);
        emit(RegisterFailure(failure.message));
      },
      (data) {
        final registerResponse = RegisterResponse.fromJson(data);
        emit(RegisterSuccess(registerResponse));
      },
    );
  }
}
