import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:gymbook/features/auth/presentation/widgets/login_screen_body.dart';

import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/network/network_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    sl<PreferencesStorage>().deleteUserToken();
    sl<NetworkService>().removeToken();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: const Scaffold(body: LoginScreenBody()),
    );
  }
}
