class EndPoints {
  static const String apiSecret = 'kJ5kHX2vCfiy0zc2mWulKgZy0TFo6pTF';

  /// Auth endpoints
  static const String registerUser = 'Authentication/register-user';
  static const String registerOwner = 'Authentication/register-owner';

  static const String login = 'Authentication/login';

  static const String googleLogin = 'Authentication/google-login';

  static const String sendOtp = 'send-otp';

  static const String verifyOtp = 'auth/verify-otp';

  static const String resendOtp = 'auth/receive-otp';

  static const String forgotPassword = 'auth/forgot-password';

  static const String resetPassword = 'auth/reset-password';

  /// Profile endpoints
  static const String profile = 'profile';

  /// Owner endpoints
  static const String createBranch = 'Owner/Branches';

  static String updateBranchWorkingHours(int branchId) =>
      'Owner/Branches/$branchId/working-hours';

  static String updateBranchLocationDetails(int branchId) =>
      'Owner/Branches/$branchId/location-details';

  static const String getBranches = 'Branches';
}
