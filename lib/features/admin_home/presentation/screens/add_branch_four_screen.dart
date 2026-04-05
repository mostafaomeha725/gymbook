import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_images_cubit/branch_images_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_setup_cubit/branch_setup_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_branch_four_screen_body.dart';

class AddBranchFourScreen extends StatelessWidget {
  final int branchId;
  final bool isEditMode;
  final int? imageId;
  final String? logoUrl;

  const AddBranchFourScreen({
    super.key,
    this.branchId = 0,
    this.isEditMode = false,
    this.imageId,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = sl<BranchSetupCubit>();
            cubit.setEditModeData(isEdit: isEditMode);
            if (isEditMode && branchId > 0) {
              cubit.fetchBranchDetails(branchId);
            }
            return cubit;
          },
        ),
        BlocProvider(create: (_) => sl<BranchImagesCubit>()),
      ],
      child: Scaffold(
        body: AddBranchFourScreenBody(
          branchId: branchId,
          isEditMode: isEditMode,
          imageId: imageId,
          logoUrl: logoUrl,
        ),
      ),
    );
  }
}
