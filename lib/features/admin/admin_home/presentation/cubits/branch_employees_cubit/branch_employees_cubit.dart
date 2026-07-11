import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin/admin_home/data/models/employee_model.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_employees_usecase.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/update_employee_usecase.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_employees_cubit/branch_employees_state.dart';

class BranchEmployeesCubit extends Cubit<BranchEmployeesState> {
  final GetBranchEmployeesUseCase getBranchEmployeesUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;
  BranchEmployeesResponse? currentResponse;
  StreamSubscription? _subscription;

  BranchEmployeesCubit({
    required this.getBranchEmployeesUseCase,
    required this.updateEmployeeUseCase,
  }) : super(BranchEmployeesInitial());

  Future<void> getBranchEmployees(int branchId, {int pageNumber = 1}) async {
    if (state is! BranchEmployeesLoaded) {
      if (pageNumber == 1) {
        emit(const BranchEmployeesLoading());
      } else {
        emit(const BranchEmployeesLoading(isPaginationLoading: true));
      }
    }

    _subscription?.cancel();
    _subscription = getBranchEmployeesUseCase(branchId, pageNumber).listen((
      result,
    ) {
      result.fold(
        (failure) {
          if (state is! BranchEmployeesLoaded) {
            emit(BranchEmployeesError(failure.message));
          }
        },
        (response) {
          currentResponse = response;
          emit(BranchEmployeesLoaded(response));
        },
      );
    });
  }

  Future<void> toggleEmployeeStatus({
    required int branchId,
    required int employeeId,
    required EmployeeModel employee,
    required bool newStatus,
  }) async {
    emit(EmployeeStatusToggling(employeeId));

    final body = <String, dynamic>{
      'branchId': employee.branchId,
      'employeeRoleId': employee.roleId,
      'firstName': employee.firstName,
      'lastName': employee.lastName,
      'email': employee.email,
      'phoneNumber': employee.phone,
      'Active': newStatus,
    };

    final result = await updateEmployeeUseCase(employeeId, body);

    result.fold(
      (failure) {
        // Restore list state on failure
        if (currentResponse != null) {
          emit(BranchEmployeesLoaded(currentResponse!));
        }
        emit(
          EmployeeStatusToggleError(
            message: failure.message,
            employeeId: employeeId,
          ),
        );
      },
      (updatedEmployee) {
        // Update local list optimistically
        if (currentResponse != null) {
          final updatedData = currentResponse!.data.map((e) {
            if (e.id == employeeId) {
              return updatedEmployee;
            }
            return e;
          }).toList();

          currentResponse = BranchEmployeesResponse(
            data: updatedData,
            currentPage: currentResponse!.currentPage,
            totalPages: currentResponse!.totalPages,
            totalCount: currentResponse!.totalCount,
            pageSize: currentResponse!.pageSize,
            hasPreviousPage: currentResponse!.hasPreviousPage,
            hasNextPage: currentResponse!.hasNextPage,
          );
          emit(BranchEmployeesLoaded(currentResponse!));
        }
        emit(
          EmployeeStatusToggleSuccess(
            employeeId: employeeId,
            newStatus: newStatus,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
