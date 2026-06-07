import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin/admin_home/data/models/employee_model.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_employees_usecase.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_employees_cubit/branch_employees_state.dart';

class BranchEmployeesCubit extends Cubit<BranchEmployeesState> {
  final GetBranchEmployeesUseCase getBranchEmployeesUseCase;
  BranchEmployeesResponse? currentResponse;

  BranchEmployeesCubit({required this.getBranchEmployeesUseCase})
    : super(BranchEmployeesInitial());

  Future<void> getBranchEmployees(int branchId, {int pageNumber = 1}) async {
    if (pageNumber == 1) {
      emit(const BranchEmployeesLoading());
    } else {
      emit(const BranchEmployeesLoading(isPaginationLoading: true));
    }

    final result = await getBranchEmployeesUseCase(branchId, pageNumber);

    result.fold((failure) => emit(BranchEmployeesError(failure.message)), (
      response,
    ) {
      currentResponse = response;
      emit(BranchEmployeesLoaded(response));
    });
  }
}
