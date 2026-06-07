import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_employees_cubit/branch_employees_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/admin_employees_screen_body.dart';

class AdminEmployeesScreen extends StatelessWidget {
  final int branchId;

  const AdminEmployeesScreen({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BranchEmployeesCubit>()..getBranchEmployees(branchId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: AdminEmployeesScreenBody(branchId: branchId),
      ),
    );
  }
}
