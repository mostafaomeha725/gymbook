import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/customer_home/presentation/cubits/nearby_branches_cubit/nearby_branches_cubit.dart';
import 'package:gymbook/features/customer_home/presentation/widgets/customer_home_screen_body.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NearbyBranchesCubit>(),
      child: const CustomerHomeScreenBody(),
    );
  }
}
