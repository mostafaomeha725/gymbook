import 'package:equatable/equatable.dart';
import 'package:gymbook/features/customer/customer_home/data/models/customer_branch_details_model.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/subscription_plan_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/opening_hours_card.dart';

abstract class CustomerBranchDetailsState extends Equatable {
  const CustomerBranchDetailsState();

  @override
  List<Object> get props => [];
}

class CustomerBranchDetailsInitial extends CustomerBranchDetailsState {}

class CustomerBranchDetailsLoading extends CustomerBranchDetailsState {}

class CustomerBranchDetailsLoaded extends CustomerBranchDetailsState {
  final CustomerBranchDetailsModel details;
  final List<String> displayImages;
  final List<WorkingHourViewModel> workingHours;
  final List<PlanModel> plans;

  const CustomerBranchDetailsLoaded({
    required this.details,
    required this.displayImages,
    required this.workingHours,
    required this.plans,
  });

  @override
  List<Object> get props => [details, displayImages, workingHours, plans];
}

class CustomerBranchDetailsError extends CustomerBranchDetailsState {
  final String message;

  const CustomerBranchDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
