import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/settings/data/models/profile_model.dart';
import 'package:gymbook/features/settings/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);
  Future<Either<Failure, ProfileModel>> call({
    required String firstName,
    required String lastName,
    required String? phoneNumber,
  }) {
    return repository.updateProfile(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
  }
}
