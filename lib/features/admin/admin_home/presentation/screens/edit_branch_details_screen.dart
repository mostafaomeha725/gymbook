import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/widgets/custom_snack_bar.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_entity.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_setup_cubit/branch_setup_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/edit_branch_details_screen_body.dart';

class EditBranchDetailsScreen extends StatelessWidget {
  final BranchEntity branch;

  const EditBranchDetailsScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<BranchSetupCubit>();
        cubit.setEditModeData(isEdit: true);
        cubit.fetchBranchDetails(branch.id);
        return cubit;
      },
      child: BlocListener<BranchSetupCubit, BranchSetupState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            CustomSnackBar.showError(context, message: state.errorMessage!);
          }
        },
        child: Scaffold(body: EditBranchDetailsScreenBody(branch: branch)),
      ),
    );
  }
}
