enum RegisterType { customer, business }

enum OtpSource { customer, business }

enum GymType { menOnly, womenOnly, mixed }

enum SubscriptionTab { active, expired }

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
}

enum AppUserRole { customer, admin }
