import 'package:gymbook/core/enums/app_enums.dart';

class UserEntity {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final AppUserRole role;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.role,
  });

  bool get isAdmin => role == AppUserRole.admin;
}
