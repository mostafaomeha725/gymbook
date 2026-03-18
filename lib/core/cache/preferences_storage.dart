import 'package:shared_preferences/shared_preferences.dart';
import '/core/cache/preferences_storage_keys.dart';

class PreferencesStorage {
  final SharedPreferences _preferences;

  PreferencesStorage(this._preferences);

  /// ================= CLEAR =================
  Future<void> clear() async {
    await _preferences.clear();
  }

  /// ================= BOOLEAN =================
  Future<void> putBoolean({
    required PreferencesKeys key,
    required bool value,
  }) async {
    await _preferences.setBool(key.name, value);
  }

  bool getBoolean({required PreferencesKeys key, bool defaultValue = false}) {
    return _preferences.getBool(key.name) ?? defaultValue;
  }

  /// ================= STRING =================
  Future<bool> putString({
    required PreferencesKeys key,
    required String? value,
  }) async {
    return await _preferences.setString(key.name, value ?? "");
  }

  String? getString({required PreferencesKeys key}) {
    return _preferences.getString(key.name);
  }

  /// ================= TOKEN =================
  Future<void> saveUserToken(String token) async {
    await _preferences.setString(PreferencesKeys.userToken.name, token);
  }

  String? getUserToken() {
    return _preferences.getString(PreferencesKeys.userToken.name);
  }

  Future<void> deleteUserToken() async {
    await _preferences.remove(PreferencesKeys.userToken.name);
  }

  /// ================= USER ROLE =================
  Future<void> saveUserRole(bool isAdmin) async {
    await _preferences.setBool(PreferencesKeys.userIsAdmin.name, isAdmin);
  }

  bool isUserAdmin() {
    return _preferences.getBool(PreferencesKeys.userIsAdmin.name) ?? false;
  }

  Future<void> deleteUserRole() async {
    await _preferences.remove(PreferencesKeys.userIsAdmin.name);
  }

  Future<void> saveUserSecretKey(String secretKey) async {
    await _preferences.setString(PreferencesKeys.userSecretKey.name, secretKey);
  }

  String? getUserSecretKey() {
    return _preferences.getString(PreferencesKeys.userSecretKey.name);
  }

  Future<void> deleteUserSecretKey() async {
    await _preferences.remove(PreferencesKeys.userSecretKey.name);
  }

  Future<void> saveUserId(int userId) async {
    await _preferences.setInt(PreferencesKeys.userId.name, userId);
  }

  int? getUserId() {
    return _preferences.getInt(PreferencesKeys.userId.name);
  }

  Future<void> deleteUserId() async {
    await _preferences.remove(PreferencesKeys.userId.name);
  }

  /// ================= LANGUAGE =================
  String getCurrentLanguage() {
    return _preferences.getString(PreferencesKeys.currentLanguage.name) ?? "en";
  }

  bool isEnglish() => getCurrentLanguage() == "en";
  bool isArabic() => getCurrentLanguage() == "ar";

  /// ================= CURRENCY =================
  String getCurrentCurrency() {
    return _preferences.getString(PreferencesKeys.currentCurrency.name) ??
        "EGP";
  }

  bool isEGP() => getCurrentCurrency() == "EGP";
  bool isUSD() => getCurrentCurrency() == "USD";
}
