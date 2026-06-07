import 'package:gymbook/features/admin/admin_home/data/models/role_model.dart';

abstract class RolesState {}

class RolesInitial extends RolesState {}

class RolesLoading extends RolesState {}

class RolesLoaded extends RolesState {
  final List<RoleModel> roles;

  RolesLoaded(this.roles);
}

class RolesError extends RolesState {
  final String message;

  RolesError(this.message);
}
