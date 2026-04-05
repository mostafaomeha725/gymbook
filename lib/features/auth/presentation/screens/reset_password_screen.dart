import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:gymbook/features/auth/presentation/widgets/reset_password_screen_body.dart';

class ResetPasswordScreenArgs {
  const ResetPasswordScreenArgs({required this.email, required this.code});

  final String email;
  final String code;
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.args});

  final ResetPasswordScreenArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ResetPasswordCubit>(),
      child: Scaffold(body: ResetPasswordScreenBody(args: args)),
    );
  }
}
