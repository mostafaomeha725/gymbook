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
  final List<EmployeeModel> items;
  final bool isFetchingMore;
  final bool hasReachedMax;

  const BranchEmployeesLoaded({
    required this.response,
    required this.items,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
  });

  BranchEmployeesLoaded copyWith({
    BranchEmployeesResponse? response,
    List<EmployeeModel>? items,
    bool? isFetchingMore,
    bool? hasReachedMax,
  }) {
    return BranchEmployeesLoaded(
      response: response ?? this.response,
      items: items ?? this.items,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [response, items, isFetchingMore, hasReachedMax];
}

class BranchEmployeesError extends BranchEmployeesState {
  final String message;

  const BranchEmployeesError(this.message);

  @override
  List<Object> get props => [message];
}

class EmployeeStatusToggling extends BranchEmployeesState {
  final int employeeId;

  const EmployeeStatusToggling(this.employeeId);

  @override
  List<Object> get props => [employeeId];
}

class EmployeeStatusToggleSuccess extends BranchEmployeesState {
  final int employeeId;
  final bool newStatus;

  const EmployeeStatusToggleSuccess({
    required this.employeeId,
    required this.newStatus,
  });

  @override
  List<Object> get props => [employeeId, newStatus];
}

class EmployeeStatusToggleError extends BranchEmployeesState {
  final String message;
  final int employeeId;

  const EmployeeStatusToggleError({
    required this.message,
    required this.employeeId,
  });

  @override
  List<Object> get props => [message, employeeId];
}
