import 'package:flutter/material.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/manage_package_screen_body.dart';

class ManagePackageScreen extends StatelessWidget {
  final int branchId;

  const ManagePackageScreen({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ManagePackageScreenBody(branchId: branchId));
  }
}
