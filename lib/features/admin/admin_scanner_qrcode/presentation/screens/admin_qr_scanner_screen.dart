import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/cubits/admin_my_branches_cubit/admin_my_branches_cubit.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/cubits/admin_qr_scanner_cubit/admin_qr_scanner_cubit.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/widgets/admin_qr_scanner_body.dart';

class AdminQrScannerScreen extends StatelessWidget {
  const AdminQrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AdminQrScannerCubit>()),
        BlocProvider(create: (_) => sl<AdminMyBranchesCubit>()..loadBranches()),
      ],
      child: const AdminQrScannerBody(),
    );
  }
}
