import 'package:flutter/material.dart';

class GetTypeColor {
  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'mixed':
        return const Color(0xFF8B5CF6); // بنفسجي
      case 'male':
        return const Color(0xFF3B82F6); // أزرق
      case 'female':
        return const Color(0xFFEC4899);
      // وردي

      case 'active':
        return const Color(0xFF4CAF50); // أخضر
      default:
        return Colors.grey;
    }
  }
}
