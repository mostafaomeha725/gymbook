import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/settings/presentation/cubits/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:gymbook/features/settings/presentation/widgets/edit_profile_screen_body.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EditProfileCubit>()..loadProfile(),
      child: const Scaffold(body: EditProfileScreenBody()),
    );
  }
}
