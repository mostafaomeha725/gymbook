import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/services/user_role_service.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/cubits/admin_my_branches_cubit/admin_my_branches_cubit.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/cubits/admin_qr_scanner_cubit/admin_qr_scanner_cubit.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/widgets/admin_qr_scanner_body.dart';

class GatorQrScannerScreen extends StatelessWidget {
  const GatorQrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roleService = sl<UserRoleService>();
    final branchName = roleService.getBranchName() ?? 'Gator Scanner';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AdminQrScannerCubit>()),
        // Gator might not need to load all branches if they only have one, 
        // but we keep the cubit to satisfy AdminQrScannerBody dependencies.
        BlocProvider(create: (_) => sl<AdminMyBranchesCubit>()..loadBranches()),
      ],
      child: AdminQrScannerBody(branchName: branchName),
    );
  }
}
