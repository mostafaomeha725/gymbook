import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/settings/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> getProfile();
  Either<Failure, ProfileModel> getCachedProfile();
  Future<Either<Failure, ProfileModel>> updateProfile({
    required String firstName,
    required String lastName,
    required String? phoneNumber,
  });
}
