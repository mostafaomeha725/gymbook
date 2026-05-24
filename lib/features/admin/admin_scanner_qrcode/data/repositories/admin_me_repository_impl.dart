import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/exceptions.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/data/datasources/admin_me_remote_datasource.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/domain/entities/admin_branch_option_entity.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/domain/repositories/admin_me_repository.dart';

class AdminMeRepositoryImpl implements AdminMeRepository {
  final AdminMeRemoteDataSource remoteDataSource;

  AdminMeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AdminBranchOptionEntity>>> getMyBranches() async {
    try {
      final models = await remoteDataSource.getMyBranches();
      final entities = models
          .map(
            (model) => AdminBranchOptionEntity(id: model.id, name: model.name),
          )
          .toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
