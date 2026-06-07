import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/add_employee_usecase.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/update_employee_usecase.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/add_edit_employee_cubit/add_edit_employee_state.dart';

class AddEditEmployeeCubit extends Cubit<AddEditEmployeeState> {
  final AddEmployeeUseCase addEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;

  AddEditEmployeeCubit({
    required this.addEmployeeUseCase,
    required this.updateEmployeeUseCase,
  }) : super(AddEditEmployeeInitial());

  Future<void> addEmployee(Map<String, dynamic> body) async {
    emit(AddEditEmployeeLoading());
    final result = await addEmployeeUseCase(body);
    result.fold(
      (failure) => emit(AddEditEmployeeError(failure.message)),
      (_) => emit(AddEditEmployeeSuccess()),
    );
  }

  Future<void> updateEmployee(int employeeId, Map<String, dynamic> body) async {
    emit(AddEditEmployeeLoading());
    final result = await updateEmployeeUseCase(employeeId, body);
    result.fold(
      (failure) => emit(AddEditEmployeeError(failure.message)),
      (_) => emit(AddEditEmployeeSuccess()),
    );
  }
}
