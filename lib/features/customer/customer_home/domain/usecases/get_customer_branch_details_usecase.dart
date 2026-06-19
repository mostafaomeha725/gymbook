import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_home/data/models/customer_branch_details_model.dart';
import 'package:gymbook/features/customer/customer_home/domain/repositories/customer_branch_details_repository.dart';

class GetCustomerBranchDetailsUseCase {
  final CustomerBranchDetailsRepository repository;

  GetCustomerBranchDetailsUseCase(this.repository);

  Stream<Either<Failure, CustomerBranchDetailsModel>> call({required int branchId}) {
    return repository.getBranchDetails(branchId: branchId);
  }
}
