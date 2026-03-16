import 'dart:convert';

class SavedLocation {
  final String id;
  final String label;
  final double latitude;
  final double longitude;

  const SavedLocation({
    required this.id,
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  static String buildId(double latitude, double longitude) {
    return '${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String toRawJson() => jsonEncode(toMap());

  static SavedLocation? tryParse(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      final map = Map<String, dynamic>.from(decoded);
      final latitude = _asDouble(map['latitude']);
      final longitude = _asDouble(map['longitude']);
      final id = (map['id'] ?? buildId(latitude, longitude)).toString();
      final label = (map['label'] ?? '').toString().trim();

      return SavedLocation(
        id: id,
        label: label,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (_) {
      return null;
    }
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
