import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branches_list_cubit/branches_list_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/admin_home_screen_body.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BranchesListCubit>()..loadBranches(),
      child: const AdminHomeScreenBody(),
    );
  }
}
