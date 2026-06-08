import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/auth/presentation/cubits/change_password_cubit/change_password_cubit.dart';
import 'package:gymbook/features/settings/presentation/widgets/change_password_screen_body.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChangePasswordCubit>(),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: ChangePasswordScreenBody(),
      ),
    );
  }
}
