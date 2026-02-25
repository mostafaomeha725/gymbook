import 'package:bloc/bloc.dart';
import 'package:gymbook/core/constants/strings.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/data/repositories/admin_branch_repository.dart';

part 'branch_location_state.dart';

class BranchLocationCubit extends Cubit<BranchLocationState> {
  BranchLocationCubit(this.repository) : super(BranchLocationInitial());

  final AdminBranchRepository repository;

  int? getGovernorateId(String? governorateName) {
    if (governorateName == null) return null;
    return AppStrings.governorateIds[governorateName];
  }

  Future<bool> submitLocationDetails({
    required int branchId,
    required String? governorateName,
    required String address,
  }) async {
    if (branchId <= 0) {
      const message = 'Invalid branch ID';
      showError(message);
      emit(BranchLocationFailure(message));
      return false;
    }

    final governorateId = getGovernorateId(governorateName);
    if (governorateId == null) {
      const message = 'Please select a governorate';
      showError(message);
      emit(BranchLocationFailure(message));
      return false;
    }

    if (address.trim().isEmpty) {
      const message = 'Please enter the address';
      showError(message);
      emit(BranchLocationFailure(message));
      return false;
    }

    emit(BranchLocationLoading());
    showLoading();

    final response = await repository.updateBranchLocationDetails(
      branchId: branchId,
      governorateId: governorateId,
      address: address.trim(),
    );

    hideLoading();

    return response.fold(
      (failure) {
        showError(failure);
        emit(BranchLocationFailure(failure));
        return false;
      },
      (_) {
        showSuccess('Location details saved successfully');
        emit(BranchLocationSuccess());
        return true;
      },
    );
  }
}
