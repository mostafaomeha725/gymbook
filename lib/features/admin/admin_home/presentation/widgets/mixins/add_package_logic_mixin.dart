import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/create_package_cubit/create_package_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/add_new_package_text_field_body.dart';

mixin AddPackageLogicMixin on State<AddNewPackageTextFieldBody> {
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController durationController;
  late final TextEditingController freezesController;
  late final TextEditingController freezeDurationController;
  late bool isActive;

  bool get isEditMode => widget.args.isEditMode;

  void initControllers() {
    final pkg = widget.args.packageItem;
    nameController = TextEditingController(text: pkg?.name ?? '');
    priceController = TextEditingController(
      text: pkg != null ? _formatPrice(pkg.price) : '',
    );
    durationController = TextEditingController(
      text: pkg != null ? pkg.durationInMonths.toString() : '',
    );
    freezesController = TextEditingController(
      text: pkg != null ? pkg.numberOfFreezes.toString() : '',
    );
    freezeDurationController = TextEditingController(
      text: pkg != null ? pkg.freezeDurationInDays.toString() : '',
    );
    isActive = pkg?.isActive ?? true;
  }

  String _formatPrice(double value) {
    final hasFraction = value % 1 != 0;
    return hasFraction ? value.toStringAsFixed(2) : value.toStringAsFixed(0);
  }

  void disposeControllers() {
    nameController.dispose();
    priceController.dispose();
    durationController.dispose();
    freezesController.dispose();
    freezeDurationController.dispose();
  }

  void submitPackage(BuildContext context) {
    final price = double.tryParse(priceController.text) ?? 0;
    if (price < 50) {
      showError('Price must be at least 50 EGP');
      return;
    }

    if (isEditMode) {
      context.read<CreatePackageCubit>().updatePackage(
        branchId: widget.args.branchId,
        packageId: widget.args.packageItem!.id,
        name: nameController.text,
        priceText: priceController.text,
        durationText: durationController.text,
        freezesText: freezesController.text,
        freezeDurationText: freezeDurationController.text,
        isActive: isActive,
      );
    } else {
      context.read<CreatePackageCubit>().submitPackage(
        branchId: widget.args.branchId,
        name: nameController.text,
        priceText: priceController.text,
        durationText: durationController.text,
        freezesText: freezesController.text,
        freezeDurationText: freezeDurationController.text,
        isActive: isActive,
      );
    }
  }
}
