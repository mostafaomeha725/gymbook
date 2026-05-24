import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/customer/customer_qrcode/presentation/cubits/entry_qrcode_cubit/entry_qrcode_cubit.dart';
import 'package:gymbook/features/customer/customer_qrcode/presentation/screens/widgets/entry_qrcode_gym_screen_body.dart';

class EntryQrcodeGymScreen extends StatelessWidget {
  const EntryQrcodeGymScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EntryQrcodeCubit>()..initialize(),
      child: const EntryQrcodeGymScreenBody(),
    );
  }
}
