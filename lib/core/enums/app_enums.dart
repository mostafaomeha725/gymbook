enum RegisterType { customer, business }

enum OtpSource { customer, business }

enum GymType { menOnly, womenOnly, mixed }

enum SubscriptionTab { all, active, expired, frozen, cancelled, scheduled }

enum RequestState { init, loading, success, error }

enum PreferencesKeys {
  currentLanguage,
  currentCurrency,
  fcmToken,
  uuid,
  name,
  picture,
  email,
  phone,
  userToken,
  userIsAdmin,
  userSecretKey,
  userId,
  userType,
  roleId,
  branchName,
  branchId,
}

/// Roles:
/// - customer  → userType = 4
/// - owner     → userType = 2
/// - branchAdmin → userType = 3, roleId = 1
/// - gator     → userType = 3, roleId = 2
enum AppUserRole { customer, owner, branchAdmin, gator }
