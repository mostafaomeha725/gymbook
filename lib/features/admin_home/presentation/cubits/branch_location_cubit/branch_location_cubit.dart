import 'package:bloc/bloc.dart';
import 'package:gymbook/core/constants/strings.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_branch_location_usecase.dart';

part 'branch_location_state.dart';

class BranchLocationCubit extends Cubit<BranchLocationState> {
  BranchLocationCubit(this.updateBranchLocationUseCase)
    : super(BranchLocationInitial());

  final UpdateBranchLocationUseCase updateBranchLocationUseCase;

  int? getGovernorateId(String? governorateName) {
    if (governorateName == null) return null;
    return AppStrings.governorateIds[governorateName];
  }

  Future<bool> submitLocationDetails({
    required int branchId,
    required String? governorateName,
    required String address,
    required double? latitude,
    required double? longitude,
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

    if (latitude == null || longitude == null) {
      const message = 'Please select location on map';
      showError(message);
      emit(BranchLocationFailure(message));
      return false;
    }

    emit(BranchLocationLoading());
    showLoading();

    final result = await updateBranchLocationUseCase(
      branchId: branchId,
      governorateId: governorateId,
      address: address.trim(),
      latitude: latitude,
      longitude: longitude,
    );

    hideLoading();

    return result.fold(
      (failure) {
        showError(failure.message);
        emit(BranchLocationFailure(failure.message));
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
