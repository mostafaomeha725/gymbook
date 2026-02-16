import 'package:flutter/material.dart';

class GetTypeColor {
  Color getTypeColor(String type) {
    switch (type.toLowerCase().trim()) {
      case 'mixed':
        return const Color(0xFF8B5CF6);
      case 'male':
        return const Color(0xFF3B82F6);
      case 'female':
        return const Color(0xFFEC4899);

      /// حالة الجيم
      case 'active':
      case 'open':
      case 'open now':
        return const Color(0xFF4CAF50);

      case 'closed':
        return const Color(0xFF991B1B);

      default:
        return Colors.grey;
    }
  }

  Color getBgColor(String type) {
    // ignore: deprecated_member_use
    return getTypeColor(type).withOpacity(0.15);
  }
}
