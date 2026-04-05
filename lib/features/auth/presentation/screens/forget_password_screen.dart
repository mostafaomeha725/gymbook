import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:gymbook/features/auth/presentation/widgets/forget_password_screen_body.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForgetPasswordCubit>(),
      child: const Scaffold(body: ForgetPasswordScreenBody()),
    );
  }
}
