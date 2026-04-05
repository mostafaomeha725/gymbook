import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/features/auth/domain/usecases/resend_confirmation_email_usecase.dart';
import 'package:gymbook/features/auth/presentation/cubits/resend_confirmation_email_cubit/resend_confirmation_email_cubit.dart';

ResendConfirmationEmailCubit buildResendConfirmationEmailCubit() {
  if (sl.isRegistered<ResendConfirmationEmailCubit>()) {
    return sl<ResendConfirmationEmailCubit>();
  }

  final useCase = sl.isRegistered<ResendConfirmationEmailUseCase>()
      ? sl<ResendConfirmationEmailUseCase>()
      : ResendConfirmationEmailUseCase(sl());

  return ResendConfirmationEmailCubit(useCase);
}
