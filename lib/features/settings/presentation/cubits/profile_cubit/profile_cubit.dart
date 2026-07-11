import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/settings/domain/usecases/get_profile_usecase.dart';
import 'package:gymbook/features/settings/domain/usecases/get_cached_profile_usecase.dart';
import 'package:gymbook/features/settings/presentation/cubits/profile_cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final GetCachedProfileUseCase getCachedProfileUseCase;

  ProfileCubit(this.getProfileUseCase, this.getCachedProfileUseCase)
    : super(ProfileInitial());

  Future<void> getProfile() async {
    // 1. Instantly load from cache if available
    final cachedResult = getCachedProfileUseCase();
    cachedResult.fold(
      (failure) => emit(ProfileLoading()), // If no cache, show loading
      (profile) => emit(ProfileLoaded(profile)),
    );

    // 2. Fetch fresh data from network in background
    final result = await getProfileUseCase();
    result.fold((failure) {
      // Only emit error if we don't have a cached profile loaded
      if (state is! ProfileLoaded) {
        emit(ProfileError(failure.message));
      }
    }, (profile) => emit(ProfileLoaded(profile)));
  }
}
