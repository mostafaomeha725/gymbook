import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/data/datasources/governorates_remote_datasource.dart';
import 'package:gymbook/features/admin_home/domain/entities/governorate_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/governorates_repository.dart';

class GovernoratesRepositoryImpl implements GovernoratesRepository {
  final GovernoratesRemoteDataSource remoteDataSource;

  GovernoratesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() async {
    try {
      final models = await remoteDataSource.getGovernorates();
      final entities = models
          .map((model) => GovernorateEntity(id: model.id, name: model.name))
          .toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
