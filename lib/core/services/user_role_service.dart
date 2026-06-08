import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/core/enums/app_enums.dart';

class UserRoleService {
  final PreferencesStorage _storage;

  UserRoleService(this._storage);

  /// Returns the current AppUserRole based on saved userType and roleId
  AppUserRole getCurrentRole() {
    final int userType = _storage.getUserType() ?? 4; // Default to Customer
    final int? roleId = _storage.getRoleId();

    switch (userType) {
      case 2:
        return AppUserRole.owner;
      case 3:
        if (roleId == 2) return AppUserRole.gator;
        return AppUserRole.branchAdmin; // Default for type 3
      case 4:
      default:
        return AppUserRole.customer;
    }
  }

  /// Check specific roles
  bool get isCustomer => getCurrentRole() == AppUserRole.customer;
  bool get isOwner => getCurrentRole() == AppUserRole.owner;
  bool get isBranchAdmin => getCurrentRole() == AppUserRole.branchAdmin;
  bool get isGator => getCurrentRole() == AppUserRole.gator;

  /// Helper methods for branch info (useful for Branch Admin and Gator)
  int? getBranchId() => _storage.getBranchId();
  String? getBranchName() => _storage.getBranchName();
}
