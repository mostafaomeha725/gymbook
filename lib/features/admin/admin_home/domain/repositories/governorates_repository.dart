import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/governorate_entity.dart';

abstract class GovernoratesRepository {
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();
}
