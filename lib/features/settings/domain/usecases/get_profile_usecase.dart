import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/settings/data/models/profile_model.dart';
import 'package:gymbook/features/settings/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);
  Future<Either<Failure, ProfileModel>> call() => repository.getProfile();
}
