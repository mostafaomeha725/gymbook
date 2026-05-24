import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_setup_cubit/branch_setup_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/add_branch_one_screen_body.dart';

class AddBranchOneScreen extends StatelessWidget {
  final BranchScreenArgs? args;

  const AddBranchOneScreen({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<BranchSetupCubit>();
        final isEditMode = args?.isEditMode == true;
        cubit.setEditModeData(isEdit: isEditMode);
        if (isEditMode && args != null && args!.branchId > 0) {
          cubit.fetchBranchDetails(args!.branchId);
        }
        return cubit;
      },
      child: Scaffold(body: AddBranchOneScreenBody(args: args)),
    );
  }
}
