import 'package:gymbook/features/auth/domain/entities/user_entity.dart';

class LoginResultEntity {
  final String accessToken;
  final UserEntity user;

  const LoginResultEntity({required this.accessToken, required this.user});
}
