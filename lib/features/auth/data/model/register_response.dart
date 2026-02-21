class RegisterResponse {
  final bool success;
  final String message;
  final RegisterData? data;
  final Map<String, dynamic> errors;
  final Map<String, dynamic> meta;

  RegisterResponse({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
    required this.meta,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? RegisterData.fromJson(json['data']) : null,
      errors: json['errors'] ?? {},
      meta: json['meta'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
      'meta': meta,
    };
  }
}

class RegisterData {
  final User user;
  final bool otpSent;

  RegisterData({required this.user, required this.otpSent});

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      user: User.fromJson(json['user']),
      otpSent: json['otp_sent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'otp_sent': otpSent};
  }
}

class User {
  final int id;
  final String fullName;
  final String email;
  final String countryCode;
  final String phoneNumber;
  final String status;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      countryCode: json['country_code'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'country_code': countryCode,
      'phone_number': phoneNumber,
      'status': status,
    };
  }
}
