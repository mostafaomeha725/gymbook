import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/utils/validators.dart';

class AuthValidator {
  static bool validateLogin({required String email, required String password}) {
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

  static bool validateEmployee({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required int? roleId,
    required String password,
    required String confirmPassword,
    required bool isEditMode,
  }) {
    if (firstName.isEmpty) {
      showError('First name is required');
      return false;
    }
    if (lastName.isEmpty) {
      showError('Last name is required');
      return false;
    }
    if (email.isEmpty) {
      showError('Email is required');
      return false;
    }
    if (!Validators.isValidEmail(email)) {
      showError('Please enter a valid email');
      return false;
    }
    if (phone.isEmpty) {
      showError('Phone number is required');
      return false;
    }
    if (!Validators.isValidEgyptianPhoneNumber(phone)) {
      showError('Phone number must be 11 digits (e.g. 01012345678)');
      return false;
    }
    if (roleId == null) {
      showError('Please select a role');
      return false;
    }

    if (!isEditMode) {
      if (password.isEmpty) {
        showError('Password is required');
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
    }

    return true;
  }
}
