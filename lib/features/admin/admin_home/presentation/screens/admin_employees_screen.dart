import 'package:flutter/material.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/admin_employees_screen_body.dart';

class AdminEmployeesScreen extends StatelessWidget {
  final int branchId;

  const AdminEmployeesScreen({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: AdminEmployeesScreenBody(branchId: branchId),
    );
  }
}
