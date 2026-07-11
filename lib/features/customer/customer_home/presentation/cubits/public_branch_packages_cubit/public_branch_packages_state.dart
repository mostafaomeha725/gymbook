import 'package:gymbook/features/customer/customer_home/data/models/public_branch_package_model.dart';

abstract class PublicBranchPackagesState {}

class PublicBranchPackagesInitial extends PublicBranchPackagesState {}

class PublicBranchPackagesLoading extends PublicBranchPackagesState {}

class PublicBranchPackagesLoaded extends PublicBranchPackagesState {
  final PublicBranchPackagesResponse response;

  PublicBranchPackagesLoaded(this.response);
}

class PublicBranchPackagesFailure extends PublicBranchPackagesState {
  final String message;

  PublicBranchPackagesFailure(this.message);
}
