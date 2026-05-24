import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_statistics_cubit/branch_statistics_cubit.dart';
import 'package:gymbook/features/admin/admin_performance/presentation/widgets/admin_performance_screen_body.dart';

class AdminPerformanceScreen extends StatelessWidget {
  const AdminPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BranchStatisticsCubit>(),
      child: const Scaffold(body: AdminPerformanceScreenBody()),
    );
  }
}
