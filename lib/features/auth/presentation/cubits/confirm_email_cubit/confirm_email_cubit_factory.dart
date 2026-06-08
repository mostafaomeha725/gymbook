import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/auth/presentation/cubits/confirm_email_cubit/confirm_email_cubit.dart';

BlocProvider<ConfirmEmailCubit> buildConfirmEmailCubit() {
  return BlocProvider<ConfirmEmailCubit>(
    create: (context) => sl<ConfirmEmailCubit>(),
  );
}
