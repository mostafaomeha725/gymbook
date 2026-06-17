import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/customer/customer_home/presentation/cubits/customer_branch_details_cubit/customer_branch_details_cubit.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_details_screen_body.dart';

class GymDetailsScreen extends StatelessWidget {
  final GymDetailsArgs args;

  const GymDetailsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => sl<CustomerBranchDetailsCubit>()..loadBranchDetails(args.branchId),
        child: GymDetailsScreenBody(args: args),
      ),
    );
  }
}
