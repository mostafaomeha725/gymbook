import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/roles_cubit/roles_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/models/add_edit_employee_screen_args.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/add_edit_employee_screen_body.dart';

class AddEditEmployeeScreen extends StatelessWidget {
  final AddEditEmployeeScreenArgs args;

  const AddEditEmployeeScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RolesCubit>()..getRoles(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: AddEditEmployeeScreenBody(args: args),
      ),
    );
  }
}
