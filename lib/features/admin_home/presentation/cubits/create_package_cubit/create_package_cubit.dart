import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/data/models/package_model.dart';
import 'package:gymbook/features/admin_home/data/repositories/admin_branch_repository.dart';

part 'create_package_state.dart';

class CreatePackageCubit extends Cubit<CreatePackageState> {
  CreatePackageCubit(this.repository) : super(CreatePackageInitial());

  final AdminBranchRepository repository;

  Future<void> submitPackage({
    required int branchId,
    required String name,
    required String priceText,
    required String durationText,
    required String freezesText,
    required bool isActive,
  }) async {
    if (name.trim().isEmpty) {
      showError("Package name can't be empty");
      emit(CreatePackageFailure("Package name can't be empty"));
      return;
    }

    final price = double.tryParse(priceText.trim());
    if (price == null || price <= 0) {
      showError('Price must be greater than 0');
      emit(CreatePackageFailure('Price must be greater than 0'));
      return;
    }

    final duration = int.tryParse(durationText.trim());
    if (duration == null || duration <= 0) {
      showError('Duration must be greater than 0');
      emit(CreatePackageFailure('Duration must be greater than 0'));
      return;
    }

    final freezes = int.tryParse(freezesText.trim()) ?? 0;

    emit(CreatePackageLoading());
    showLoading();

    final request = CreatePackageRequest(
      branchId: branchId,
      name: name.trim(),
      price: price,
      durationInMonths: duration,
      isActive: isActive,
      numberOfFreezes: freezes,
    );

    final result = await repository.createPackage(
      branchId: branchId,
      request: request,
    );

    hideLoading();

    result.fold(
      (failure) {
        showError(failure);
        emit(CreatePackageFailure(failure));
      },
      (response) {
        showSuccess('Package created successfully');
        emit(CreatePackageSuccess(response));
      },
    );
  }
}
