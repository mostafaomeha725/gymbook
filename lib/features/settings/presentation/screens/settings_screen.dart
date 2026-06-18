import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/settings/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:gymbook/features/settings/presentation/widgets/settings_screen_body.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..getProfile(),
      child: const SettingsScreenBody(),
    );
  }
}
