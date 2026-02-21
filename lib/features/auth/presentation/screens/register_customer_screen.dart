import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/auth/presentation/cubits/register_cubit/register_cubit.dart';
import 'package:gymbook/features/auth/presentation/widgets/register_cutomer_screen_body.dart';

class RegisterCustomerScreen extends StatelessWidget {
  const RegisterCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: const Scaffold(body: RegisterCutomerScreenBody()),
    );
  }
}
