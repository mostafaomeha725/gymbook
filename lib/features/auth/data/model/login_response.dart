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

  LoginUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
    };
  }
}
