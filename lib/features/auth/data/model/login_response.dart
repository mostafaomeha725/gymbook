import 'package:gymbook/core/enums/app_enums.dart';

class LoginResponse {
  final String accessToken;
  final RefreshToken refreshToken;
  final LoginUser user;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: RefreshToken.fromJson(json['refreshToken'] ?? {}),
      user: LoginUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken.toJson(),
      'user': user.toJson(),
    };
  }
}

AppUserRole parseAppUserRole(dynamic rawRole) {
  if (rawRole is int) {
    return rawRole == 1 ? AppUserRole.admin : AppUserRole.customer;
  }

  if (rawRole is String) {
    final normalized = rawRole.trim().toLowerCase();
    if (normalized == '1' || normalized == 'admin' || normalized == 'owner') {
      return AppUserRole.admin;
    }
    if (normalized == '0' || normalized == 'customer') {
      return AppUserRole.customer;
    }
  }

  return AppUserRole.customer;
}

class RefreshToken {
  final String token;
  final int userId;
  final String expirationDate;

  RefreshToken({
    required this.token,
    required this.userId,
    required this.expirationDate,
  });

  factory RefreshToken.fromJson(Map<String, dynamic> json) {
    return RefreshToken(
      token: json['token'] ?? '',
      userId: json['userId'] ?? 0,
      expirationDate: json['expirationDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'userId': userId, 'expirationDate': expirationDate};
  }
}

class LoginUser {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final AppUserRole role;

  LoginUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.role,
  });

  bool get isAdmin => role == AppUserRole.admin;

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      role: parseAppUserRole(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'role': role == AppUserRole.admin ? 1 : 0,
    };
  }
}
