import 'package:gymbook/core/enums/app_enums.dart';

class UserEntity {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final int userType;
  final int? roleId;
  final int? branchId;
  final String? branchName;
  final AppUserRole role;
  final bool emailConfirmed;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.userType,
    this.roleId,
    this.branchId,
    this.branchName,
    required this.role,
    required this.emailConfirmed,
  });

  bool get isAdmin =>
      role == AppUserRole.owner || role == AppUserRole.branchAdmin;
}
