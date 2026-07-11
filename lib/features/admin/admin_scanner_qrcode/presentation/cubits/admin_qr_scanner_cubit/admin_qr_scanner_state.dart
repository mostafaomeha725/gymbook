part of 'admin_qr_scanner_cubit.dart';

class AdminQrScannerState {
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  /// Populated after a successful scan
  final CheckInResultModel? scanResult;

  const AdminQrScannerState({
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
    this.scanResult,
  });

  factory AdminQrScannerState.initial() => const AdminQrScannerState();

  AdminQrScannerState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
    CheckInResultModel? scanResult,
    bool clearMessages = false,
    bool clearScanResult = false,
  }) {
    return AdminQrScannerState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages
          ? null
          : (successMessage ?? this.successMessage),
      scanResult: clearScanResult ? null : (scanResult ?? this.scanResult),
    );
  }
}
