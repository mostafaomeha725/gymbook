import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/utils/validators.dart';

class AuthValidator {
  static bool validateLogin({
    required String email,
    required String password,
  }) {
    if (email.isEmpty) {
      showError('Please enter your email');
      return false;
    }
    if (!Validators.isValidEmail(email)) {
      showError('Please enter a valid email');
      return false;
    }
    if (password.isEmpty) {
      showError('Please enter your password');
      return false;
    }
    return true;
  }

  static bool validateRegister({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) {
    if (firstName.isEmpty) {
      showError('Please enter your first name');
      return false;
    }
    if (lastName.isEmpty) {
      showError('Please enter your last name');
      return false;
    }
    if (email.isEmpty) {
      showError('Please enter your email');
      return false;
    }
    if (!Validators.isValidEmail(email)) {
      showError('Please enter a valid email');
      return false;
    }
    if (phone.isEmpty) {
      showError('Please enter your phone number');
      return false;
    }
    if (!Validators.isValidInternationalPhoneNumber(phone)) {
      showError('Phone number is not valid');
      return false;
    }
    if (password.isEmpty) {
      showError('Please enter a password');
      return false;
    }

    final passwordErrors = Validators.getPasswordValidationErrors(password);
    if (passwordErrors.isNotEmpty) {
      showError(passwordErrors.first);
      return false;
    }

    if (confirmPassword.isEmpty) {
      showError('Please confirm your password');
      return false;
    }
    if (password != confirmPassword) {
      showError('Passwords do not match');
      return false;
    }

    return true;
  }
}
