import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/admin_home/data/models/package_screen_args.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/create_package_cubit/create_package_cubit.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/add_new_package_screen_body.dart';

class AddNewPackageScreen extends StatelessWidget {
  final PackageScreenArgs args;

  const AddNewPackageScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreatePackageCubit>(),
      child: Scaffold(body: AddNewPackageScreenBody(args: args)),
    );
  }
}
