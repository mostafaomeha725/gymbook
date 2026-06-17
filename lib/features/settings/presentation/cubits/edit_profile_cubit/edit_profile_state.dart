import 'package:gymbook/features/settings/data/models/profile_model.dart';

abstract class EditProfileState {}
class EditProfileInitial extends EditProfileState {}
class EditProfileLoading extends EditProfileState {}
class EditProfileLoaded extends EditProfileState {
  final ProfileModel profile;
  EditProfileLoaded(this.profile);
}
class EditProfileError extends EditProfileState {
  final String message;
  EditProfileError(this.message);
}
class EditProfileUpdating extends EditProfileState {}
class EditProfileUpdated extends EditProfileState {
  final ProfileModel profile;
  EditProfileUpdated(this.profile);
}
class EditProfileUpdateError extends EditProfileState {
  final String message;
  EditProfileUpdateError(this.message);
}
