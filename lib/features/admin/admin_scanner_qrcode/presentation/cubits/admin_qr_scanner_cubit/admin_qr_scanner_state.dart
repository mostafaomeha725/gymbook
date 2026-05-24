part of 'admin_qr_scanner_cubit.dart';

class AdminQrScannerState {
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const AdminQrScannerState({
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
  });

  factory AdminQrScannerState.initial() => const AdminQrScannerState();

  AdminQrScannerState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return AdminQrScannerState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}
