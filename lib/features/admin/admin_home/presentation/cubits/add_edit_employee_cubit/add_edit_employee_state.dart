import 'package:equatable/equatable.dart';

abstract class AddEditEmployeeState extends Equatable {
  const AddEditEmployeeState();

  @override
  List<Object> get props => [];
}

class AddEditEmployeeInitial extends AddEditEmployeeState {}

class AddEditEmployeeLoading extends AddEditEmployeeState {}

class AddEditEmployeeSuccess extends AddEditEmployeeState {}

class AddEditEmployeeError extends AddEditEmployeeState {
  final String message;

  const AddEditEmployeeError(this.message);

  @override
  List<Object> get props => [message];
}
