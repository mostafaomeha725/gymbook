import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/settings/domain/usecases/get_profile_usecase.dart';
import 'package:gymbook/features/settings/domain/usecases/update_profile_usecase.dart';
import 'package:gymbook/features/settings/presentation/cubits/edit_profile_cubit/edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  EditProfileCubit(this.getProfileUseCase, this.updateProfileUseCase)
    : super(EditProfileInitial());

  Future<void> loadProfile() async {
    emit(EditProfileLoading());
    final result = await getProfileUseCase();
    result.fold(
      (failure) => emit(EditProfileError(failure.message)),
      (profile) => emit(EditProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String? phoneNumber,
  }) async {
    emit(EditProfileUpdating());
    final result = await updateProfileUseCase(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
    result.fold((failure) => emit(EditProfileUpdateError(failure.message)), (
      profile,
    ) {
      emit(EditProfileUpdated(profile));
      emit(EditProfileLoaded(profile));
    });
  }
}
