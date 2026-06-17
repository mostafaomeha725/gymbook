import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/features/customer/customer_home/data/models/customer_branch_details_model.dart';

abstract class CustomerBranchDetailsRepository {
  Future<Either<Failure, CustomerBranchDetailsModel>> getBranchDetails({required int branchId});
}
