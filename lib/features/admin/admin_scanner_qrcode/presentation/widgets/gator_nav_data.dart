import 'package:flutter/material.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/screens/gator_qr_scanner_screen.dart';
import 'package:gymbook/features/settings/presentation/screens/settings_screen.dart';

class GatorNavData {
  static final List<Map<String, dynamic>> items = [
    {'label': 'Scanner', 'icon': Icons.qr_code_scanner_rounded},
    {'label': 'Settings', 'icon': Icons.settings_rounded},
  ];

  static const List<Widget> screens = [
    GatorQrScannerScreen(),
    SettingsScreen(),
  ];
}
