import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin/admin_home/data/models/branch_list_model.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_location_cubit/branch_location_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_setup_cubit/branch_setup_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/add_branch_two_screen_body.dart';

class AddBranchTwoScreen extends StatelessWidget {
  final int branchId;
  final BranchScreenArgs? args;

  const AddBranchTwoScreen({super.key, this.branchId = 0, this.args});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<BranchLocationCubit>()),
        BlocProvider(
          create: (_) {
            final cubit = sl<BranchSetupCubit>();
            final isEditMode = args?.isEditMode == true;
            cubit.setEditModeData(isEdit: isEditMode);
            if (isEditMode && branchId > 0) {
              cubit.fetchBranchDetails(branchId);
            }
            return cubit;
          },
        ),
      ],
      child: Scaffold(
        body: AddBranchTwoScreenBody(branchId: branchId, args: args),
      ),
    );
  }
}
