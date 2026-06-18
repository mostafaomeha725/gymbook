import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/settings/data/models/profile_model.dart';
import 'package:gymbook/features/settings/domain/repositories/profile_repository.dart';

class GetCachedProfileUseCase {
  final ProfileRepository repository;
  GetCachedProfileUseCase(this.repository);
  Either<Failure, ProfileModel> call() => repository.getCachedProfile();
}
