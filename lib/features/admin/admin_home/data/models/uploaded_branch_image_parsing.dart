class UploadedBranchImageParsing {
  static Map<String, dynamic>? extractPayload(dynamic response) {
    if (response is! Map<String, dynamic>) return null;

    if (response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }

    return response;
  }

  static int? asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? asString(dynamic value) {
    if (value == null) return null;
    final result = value.toString().trim();
    return result.isEmpty ? null : result;
  }
}
