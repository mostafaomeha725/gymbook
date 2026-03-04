import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/admin_home/domain/entities/subscription_item_entity.dart';
import 'package:gymbook/features/admin_home/domain/repositories/admin_branch_repository.dart';

class GetBranchSubscriptionsUseCase {
  final AdminBranchRepository repository;
  GetBranchSubscriptionsUseCase(this.repository);

  Future<Either<Failure, SubscriptionsListEntity>> call({
    required int branchId,
    required int pageNumber,
    required int pageSize,
    String? search,
    int? status,
  }) {
    return repository.getBranchSubscriptions(
      branchId: branchId,
      pageNumber: pageNumber,
      pageSize: pageSize,
      search: search,
      status: status,
    );
  }
}
