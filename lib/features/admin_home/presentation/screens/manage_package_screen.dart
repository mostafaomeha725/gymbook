import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/branch_packages_list_cubit/branch_packages_list_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/create_package_cubit/create_package_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/manage_package_screen_body.dart';

class ManagePackageScreen extends StatelessWidget {
  final int branchId;

  const ManagePackageScreen({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<BranchPackagesListCubit>()..loadPackages(branchId: branchId),
        ),
        BlocProvider(create: (_) => sl<CreatePackageCubit>()),
      ],
      child: Scaffold(body: ManagePackageScreenBody(branchId: branchId)),
    );
  }
}
