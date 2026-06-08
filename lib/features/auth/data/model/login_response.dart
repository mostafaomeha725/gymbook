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

// ──────────────────────────────────────────────────────────
// WorksAtBranch
// ──────────────────────────────────────────────────────────

class WorksAtBranch {
  final int branchId;
  final String branchName;
  final int roleId;
  final String roleName;

  const WorksAtBranch({
    required this.branchId,
    required this.branchName,
    required this.roleId,
    required this.roleName,
  });

  factory WorksAtBranch.fromJson(Map<String, dynamic> json) {
    return WorksAtBranch(
      branchId: json['branchId'] as int? ?? 0,
      branchName: json['branchName'] as String? ?? '',
      roleId: json['roleId'] as int? ?? 0,
      roleName: json['roleName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'branchId': branchId,
    'branchName': branchName,
    'roleId': roleId,
    'roleName': roleName,
  };
}

// ──────────────────────────────────────────────────────────
// Role resolution
// ──────────────────────────────────────────────────────────

/// Maps userType + optional roleId to [AppUserRole].
AppUserRole resolveAppUserRole({
  required int userType,
  int? roleId,
}) {
  switch (userType) {
    case 2:
      return AppUserRole.owner;
    case 3:
      if (roleId == 2) return AppUserRole.gator;
      return AppUserRole.branchAdmin; // roleId == 1 (default for type 3)
    case 4:
    default:
      return AppUserRole.customer;
  }
}

// ──────────────────────────────────────────────────────────
// Keep backward-compat helper used elsewhere in register flow
// ──────────────────────────────────────────────────────────
AppUserRole parseAppUserRole(dynamic rawRole) {
  if (rawRole is int) {
    return (rawRole == 2) ? AppUserRole.owner : AppUserRole.customer;
  }
  if (rawRole is String) {
    final normalized = rawRole.trim().toLowerCase();
    if (['2', 'admin', 'owner', 'partneradmin'].contains(normalized)) {
      return AppUserRole.owner;
    }
  }
  return AppUserRole.customer;
}

// ──────────────────────────────────────────────────────────
// RefreshToken
// ──────────────────────────────────────────────────────────

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

// ──────────────────────────────────────────────────────────
// LoginUser
// ──────────────────────────────────────────────────────────

class LoginUser {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String secretKey;
  final int userType;
  final WorksAtBranch? worksAtBranch;
  final AppUserRole role;
  final bool emailConfirmed;

  LoginUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.secretKey,
    required this.userType,
    this.worksAtBranch,
    required this.role,
    required this.emailConfirmed,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    final int userType = json['userType'] as int? ?? 4;
    final worksAtBranchJson = json['worksAtBranch'];
    final WorksAtBranch? worksAtBranch =
        worksAtBranchJson != null && worksAtBranchJson is Map<String, dynamic>
        ? WorksAtBranch.fromJson(worksAtBranchJson)
        : null;

    final int? roleId = worksAtBranch?.roleId;

    return LoginUser(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      secretKey: (json['secretKey'] ?? '').toString(),
      userType: userType,
      worksAtBranch: worksAtBranch,
      role: resolveAppUserRole(userType: userType, roleId: roleId),
      emailConfirmed: json['emailConfirmed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'secretKey': secretKey,
      'userType': userType,
      'emailConfirmed': emailConfirmed,
      if (worksAtBranch != null) 'worksAtBranch': worksAtBranch!.toJson(),
    };
  }
}
