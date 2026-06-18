/// Validators for authentication forms
/// Provides email, password, and confirm password validation
library;

class EmailValidator {
  /// Validates email address format
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return 'Please enter your email';
    }

    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }

    return null;
  }
}

class PasswordValidator {
  /// Validates password with optional minimum length
  static String? validate(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }
}

class ConfirmPasswordValidator {
  /// Validates that confirm password matches the original password
  static String? validate(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}
