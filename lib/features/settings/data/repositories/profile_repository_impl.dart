import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/settings/data/datasources/profile_remote_datasource.dart';
import 'package:gymbook/features/settings/data/models/profile_model.dart';
import 'package:gymbook/features/settings/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final PreferencesStorage preferencesStorage;

  ProfileRepositoryImpl(this.remoteDataSource, this.preferencesStorage);

  @override
  Either<Failure, ProfileModel> getCachedProfile() {
    final cachedProfileString = preferencesStorage.getUserProfile();
    if (cachedProfileString != null && cachedProfileString.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(cachedProfileString);
        return Right(ProfileModel.fromJson(jsonMap));
      } catch (e) {
        return const Left(CacheFailure(message: "Failed to parse profile cache"));
      }
    }
    return const Left(CacheFailure(message: "No cached profile found"));
  }

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    // Always try to fetch from network to get latest updates
    try {
      final result = await remoteDataSource.getProfile();
      // Cache the result
      final profileJsonString = jsonEncode(result.toJson());
      await preferencesStorage.saveUserProfile(profileJsonString);
      return Right(result);
    } catch (e) {
      // On network failure, fallback to cache
      final cachedResult = getCachedProfile();
      if (cachedResult.isRight()) {
        return cachedResult;
      }
      if (e is ServerException) {
        return Left(ServerFailure(message: e.message));
      }
      return const Left(ServerFailure(message: "Network Error"));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      final result = await remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
      // Cache the updated result
      final profileJsonString = jsonEncode(result.toJson());
      await preferencesStorage.saveUserProfile(profileJsonString);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
