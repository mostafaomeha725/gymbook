import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin/admin_home/data/models/employee_model.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_employees_usecase.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_employees_cubit/branch_employees_state.dart';

class BranchEmployeesCubit extends Cubit<BranchEmployeesState> {
  final GetBranchEmployeesUseCase getBranchEmployeesUseCase;
  BranchEmployeesResponse? currentResponse;
  StreamSubscription? _subscription;

  BranchEmployeesCubit({required this.getBranchEmployeesUseCase})
    : super(BranchEmployeesInitial());

  Future<void> getBranchEmployees(int branchId, {int pageNumber = 1}) async {
    if (state is! BranchEmployeesLoaded) {
      if (pageNumber == 1) {
        emit(const BranchEmployeesLoading());
      } else {
        emit(const BranchEmployeesLoading(isPaginationLoading: true));
      }
    }

    _subscription?.cancel();
    _subscription = getBranchEmployeesUseCase(branchId, pageNumber).listen((result) {
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

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
