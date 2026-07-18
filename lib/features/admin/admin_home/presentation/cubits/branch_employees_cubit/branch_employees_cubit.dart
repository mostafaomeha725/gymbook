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
  bool _isFetchingMore = false;
  bool get isFetchingMore => _isFetchingMore;
  List<EmployeeModel> _accumulatedItems = [];
  List<EmployeeModel> get items => _accumulatedItems;
  int _currentPage = 1;
  late int _currentBranchId;

  BranchEmployeesCubit({
    required this.getBranchEmployeesUseCase,
    required this.updateEmployeeUseCase,
  }) : super(BranchEmployeesInitial());

  Future<void> getBranchEmployees(
    int branchId, {
    bool isRefresh = false,
  }) async {
    _currentBranchId = branchId;
    if (isRefresh || _currentPage == 1) {
      _accumulatedItems.clear();
      _currentPage = 1;
    }

    if (state is! BranchEmployeesLoaded) {
      emit(const BranchEmployeesLoading());
    }

    _subscription?.cancel();
    _subscription = getBranchEmployeesUseCase(branchId, _currentPage).listen((
      result,
    ) {
      result.fold(
        (failure) {
          if (isClosed) return;
          emit(BranchEmployeesError(failure.message));
        },
        (response) {
          if (isClosed) return;
          currentResponse = response;
          if (_currentPage == 1) {
            _accumulatedItems = List.from(response.data);
          } else {
            _accumulatedItems.addAll(response.data);
          }

          emit(
            BranchEmployeesLoaded(
              response: response,
              items: List.from(_accumulatedItems),
              isFetchingMore: false,
              hasReachedMax: _currentPage >= response.totalPages || response.data.isEmpty,
            ),
          );
        },
      );
    });
  }

  Future<void> loadMore() async {
    if (_isFetchingMore) return;
    if (state is! BranchEmployeesLoaded) return;

    final currentState = state as BranchEmployeesLoaded;
    if (currentState.hasReachedMax) return;

    _isFetchingMore = true;
    _currentPage++;
    emit(currentState.copyWith(isFetchingMore: true));

    _subscription?.cancel();
    _subscription = getBranchEmployeesUseCase(_currentBranchId, _currentPage)
        .listen((result) {
          _isFetchingMore = false;
          result.fold(
            (failure) {
              if (isClosed) return;
              _currentPage--;
              emit(currentState.copyWith(isFetchingMore: false));
            },
            (response) {
              currentResponse = response;
              _accumulatedItems.addAll(response.data);

              emit(
                BranchEmployeesLoaded(
                  response: response,
                  items: List.from(_accumulatedItems),
                  isFetchingMore: false,
                  hasReachedMax: _currentPage >= response.totalPages || response.data.isEmpty,
                ),
              );
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
          emit(
            BranchEmployeesLoaded(
              response: currentResponse!,
              items: List.from(_accumulatedItems),
              isFetchingMore: false,
              hasReachedMax: _currentPage >= currentResponse!.totalPages || currentResponse!.data.isEmpty,
            ),
          );
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

          final updatedAccumulated = _accumulatedItems.map((e) {
            if (e.id == employeeId) return updatedEmployee;
            return e;
          }).toList();
          _accumulatedItems = updatedAccumulated;

          emit(
            (state as BranchEmployeesLoaded).copyWith(
              response: currentResponse!,
              items: List.from(_accumulatedItems),
            ),
          );
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
