import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/auth/domain/entities/user_entity.dart';
import 'package:gymbook/features/auth/domain/usecases/register_usecase.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.registerUseCase) : super(RegisterInitial());

  final RegisterUseCase registerUseCase;

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

    final result = await registerUseCase(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
      isOwner: isOwner,
    );

    hideLoading();

    result.fold((failure) {
      showError(failure.message);
      emit(RegisterFailure(failure.message));
    }, (user) => emit(RegisterSuccess(user)));
  }
}
