import 'package:flutter/material.dart';
import 'package:gymbook/core/utils/easy_loading.dart';

class AdminScannerSnackbar {
  static void show(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    if (isError) {
      showError(message);
    } else {
      showSuccess(message);
    }
  }
}
