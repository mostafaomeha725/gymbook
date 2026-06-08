import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/services/user_role_service.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/cubits/admin_qr_scanner_cubit/admin_qr_scanner_cubit.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/widgets/admin_qr_scanner_body.dart';

class GatorQrScannerScreen extends StatelessWidget {
  const GatorQrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roleService = sl<UserRoleService>();
    final branchName = roleService.getBranchName() ?? 'Gator Scanner';
    final branchId = roleService.getBranchId();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AdminQrScannerCubit>()),
        // We don't need AdminMyBranchesCubit here because the branch is fixed
      ],
      child: AdminQrScannerBody(
        branchName: branchName,
        fixedBranchId: branchId,
      ),
    );
  }
}
