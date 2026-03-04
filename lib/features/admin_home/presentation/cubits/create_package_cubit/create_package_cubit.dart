import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin_home/domain/entities/created_package_entity.dart';
import 'package:gymbook/features/admin_home/domain/usecases/create_package_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/delete_package_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_package_status_usecase.dart';
import 'package:gymbook/features/admin_home/domain/usecases/update_package_usecase.dart';

part 'create_package_state.dart';

class CreatePackageCubit extends Cubit<CreatePackageState> {
  CreatePackageCubit({
    required this.createPackageUseCase,
    required this.updatePackageUseCase,
    required this.updatePackageStatusUseCase,
    required this.deletePackageUseCase,
  }) : super(CreatePackageInitial());

  final CreatePackageUseCase createPackageUseCase;
  final UpdatePackageUseCase updatePackageUseCase;
  final UpdatePackageStatusUseCase updatePackageStatusUseCase;
  final DeletePackageUseCase deletePackageUseCase;

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

    final result = await createPackageUseCase(
      branchId: branchId,
      name: name.trim(),
      price: price,
      durationInMonths: duration,
      isActive: isActive,
      numberOfFreezes: freezes,
    );

    hideLoading();

    result.fold(
      (failure) {
        showError(failure.message);
        emit(CreatePackageFailure(failure.message));
      },
      (entity) {
        showSuccess('Package created successfully');
        emit(CreatePackageSuccess(entity));
      },
    );
  }

  Future<void> updatePackage({
    required int branchId,
    required int packageId,
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

    final result = await updatePackageUseCase(
      branchId: branchId,
      packageId: packageId,
      name: name.trim(),
      price: price,
      durationInMonths: duration,
      isActive: isActive,
      numberOfFreezes: freezes,
    );

    hideLoading();

    result.fold(
      (failure) {
        showError(failure.message);
        emit(CreatePackageFailure(failure.message));
      },
      (entity) {
        showSuccess('Package updated successfully');
        emit(CreatePackageSuccess(entity));
      },
    );
  }

  Future<void> togglePackageStatus({
    required int branchId,
    required int packageId,
    required bool isActive,
  }) async {
    emit(CreatePackageLoading());
    showLoading();

    final result = await updatePackageStatusUseCase(
      branchId: branchId,
      packageId: packageId,
      isActive: isActive,
    );

    hideLoading();

    result.fold((failure) {
      showError(failure.message);
      emit(CreatePackageFailure(failure.message));
    }, (_) => emit(PackageStatusUpdated()));
  }

  Future<void> deletePackage({
    required int branchId,
    required int packageId,
  }) async {
    emit(CreatePackageLoading());
    showLoading();

    final result = await deletePackageUseCase(
      branchId: branchId,
      packageId: packageId,
    );

    hideLoading();

    result.fold((failure) {
      showError(failure.message);
      emit(CreatePackageFailure(failure.message));
    }, (_) => emit(PackageDeleted()));
  }
}
