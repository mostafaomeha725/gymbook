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
}

enum AppUserRole { customer, admin }
