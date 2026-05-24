import 'package:flutter/material.dart';
import 'package:gymbook/features/admin/admin_home/presentation/screens/admin_home_screen.dart';
import 'package:gymbook/features/admin/admin_scanner_qrcode/presentation/screens/admin_qr_scanner_screen.dart';
import 'package:gymbook/features/settings/presentation/screens/settings_screen.dart';

class AdminNavData {
  static final List<Map<String, dynamic>> items = [
    {'label': 'Home', 'icon': Icons.home_rounded},
    {'label': 'Branches', 'icon': Icons.store_rounded},
    {'label': 'Scanner', 'icon': Icons.qr_code_scanner_rounded},
    {'label': 'Settings', 'icon': Icons.settings_rounded},
  ];

  static const List<Widget> screens = [
    AdminHomeScreen(),
    AdminHomeScreen(),
    AdminQrScannerScreen(),
    SettingsScreen(),
  ];
}
