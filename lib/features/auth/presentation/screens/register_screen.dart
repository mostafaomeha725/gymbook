import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/auth/presentation/cubits/register_cubit/register_cubit.dart';
import 'package:gymbook/features/auth/presentation/widgets/register_screen_body.dart';
export 'package:gymbook/core/enums/app_enums.dart' show RegisterType;
import 'package:gymbook/core/enums/app_enums.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterType type;

  const RegisterScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: Scaffold(body: RegisterScreenBody(type: type)),
    );
  }
}
