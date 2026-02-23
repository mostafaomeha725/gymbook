import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_working_hours_cubit/branch_working_hours_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_branch_three_screen_body.dart';

class AddBranchThreeScreen extends StatelessWidget {
  final int branchId;

  const AddBranchThreeScreen({super.key, this.branchId = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BranchWorkingHoursCubit>(),
      child: Scaffold(body: AddBranchThreeScreenBody(branchId: branchId)),
    );
  }
}
