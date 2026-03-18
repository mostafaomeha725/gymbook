import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/governorate_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/governorates_repository.dart';

class GetGovernoratesUseCase {
  final GovernoratesRepository repository;

  GetGovernoratesUseCase(this.repository);

  Future<Either<Failure, List<GovernorateEntity>>> call() {
    return repository.getGovernorates();
  }
}
