import 'package:equatable/equatable.dart';
import 'package:gymbook/features/admin/admin_home/data/models/employee_model.dart';

abstract class BranchEmployeesState extends Equatable {
  const BranchEmployeesState();

  @override
  List<Object> get props => [];
}

class BranchEmployeesInitial extends BranchEmployeesState {}

class BranchEmployeesLoading extends BranchEmployeesState {
  final bool isPaginationLoading;
  
  const BranchEmployeesLoading({this.isPaginationLoading = false});

  @override
  List<Object> get props => [isPaginationLoading];
}

class BranchEmployeesLoaded extends BranchEmployeesState {
  final BranchEmployeesResponse response;

  const BranchEmployeesLoaded(this.response);

  @override
  List<Object> get props => [response];
}

class BranchEmployeesError extends BranchEmployeesState {
  final String message;

  const BranchEmployeesError(this.message);

  @override
  List<Object> get props => [message];
}
