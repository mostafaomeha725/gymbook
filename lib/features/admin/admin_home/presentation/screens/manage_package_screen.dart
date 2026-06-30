import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/services/notification_refresh_service.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/branch_packages_list_cubit/branch_packages_list_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/create_package_cubit/create_package_cubit.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/manage_package_screen_body.dart';

class ManagePackageScreen extends StatefulWidget {
  final int branchId;

  const ManagePackageScreen({super.key, required this.branchId});

  @override
  State<ManagePackageScreen> createState() => _ManagePackageScreenState();
}

class _ManagePackageScreenState extends State<ManagePackageScreen> {
  late final BranchPackagesListCubit _packagesCubit;
  StreamSubscription<int>? _refreshSubscription;

  @override
  void initState() {
    super.initState();
    _packagesCubit = sl<BranchPackagesListCubit>()
      ..loadPackages(branchId: widget.branchId);

    // Auto-refresh on BranchPackagesUpdate (type 5) notification
    _refreshSubscription = NotificationRefreshService().stream.listen((type) {
      if (type == 5) {
        _packagesCubit.loadPackages(branchId: widget.branchId);
      }
    });
  }

  @override
  void dispose() {
    _refreshSubscription?.cancel();
    _packagesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _packagesCubit),
        BlocProvider(create: (_) => sl<CreatePackageCubit>()),
      ],
      child: Scaffold(body: ManagePackageScreenBody(branchId: widget.branchId)),
    );
  }
}

