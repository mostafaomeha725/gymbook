import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_location_cubit/branch_location_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_branch_two_screen_body.dart';

class AddBranchTwoScreen extends StatelessWidget {
  final int branchId;

  const AddBranchTwoScreen({super.key, this.branchId = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BranchLocationCubit>(),
      child: Scaffold(body: AddBranchTwoScreenBody(branchId: branchId)),
    );
  }
}
