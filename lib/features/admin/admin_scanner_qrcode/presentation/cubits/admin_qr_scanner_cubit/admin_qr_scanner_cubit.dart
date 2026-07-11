import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/data/models/checkin_result_model.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/domain/usecases/add_checkin_usecase.dart';

part 'admin_qr_scanner_state.dart';

class AdminQrScannerCubit extends Cubit<AdminQrScannerState> {
  AdminQrScannerCubit(this.addCheckInUseCase)
    : super(AdminQrScannerState.initial());

  final AddCheckInUseCase addCheckInUseCase;

  bool _isBusy = false;

  Future<void> submitFromScannedPayload({
    required String rawValue,
    required int branchId,
  }) async {
    if (_isBusy || state.isSubmitting) return;

    final payload = _parsePayload(rawValue);
    if (payload == null) {
      emit(
        state.copyWith(errorMessage: 'Invalid QR payload', clearMessages: true),
      );
      return;
    }

    _isBusy = true;
    emit(
      state.copyWith(
        isSubmitting: true,
        clearMessages: true,
        clearScanResult: true,
      ),
    );

    final result = await addCheckInUseCase(
      customerId: payload.customerId,
      code: payload.code,
      branchId: branchId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, errorMessage: failure.message),
      ),
      (checkInResult) => emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'Check-in added successfully',
          scanResult: checkInResult,
        ),
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 1200));
    _isBusy = false;
  }

  void clearMessage() {
    emit(state.copyWith(clearMessages: true));
  }

  void clearScanResult() {
    emit(state.copyWith(clearScanResult: true));
  }

  _ScannedPayload? _parsePayload(String rawValue) {
    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is Map<String, dynamic>) {
        final customerId = (decoded['customerId'] as num?)?.toInt();
        final code = (decoded['code'] ?? '').toString();
        if (customerId != null && customerId > 0 && code.trim().isNotEmpty) {
          return _ScannedPayload(customerId: customerId, code: code.trim());
        }
      }
    } catch (_) {
      // Not JSON payload
    }

    return null;
  }
}

class _ScannedPayload {
  final int customerId;
  final String code;

  const _ScannedPayload({required this.customerId, required this.code});
}
