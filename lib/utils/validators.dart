// lib/utils/validators.dart

class Validators {
  /// Email validation with regex
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  /// Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Simple password validation (length only)
  static String? validateSimplePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }

    if (RegExp(r'[0-9]').hasMatch(value)) {
      return 'Name cannot contain numbers';
    }

    return null;
  }

  /// Phone number validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegExp = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Enter a valid phone number';
    }

    if (value.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    return null;
  }

  /// Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Required field validation
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    return null;
  }

  /// Minimum length validation
  static String? validateMinLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (value.length < minLength) {
      return '${fieldName ?? 'Field'} must be at least $minLength characters';
    }

    return null;
  }

  /// Maximum length validation
  static String? validateMaxLength(String? value, int maxLength, [String? fieldName]) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'Field'} must be less than $maxLength characters';
    }

    return null;
  }

  /// Numeric validation
  static String? validateNumeric(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'Field'} must be a number';
    }

    return null;
  }

  /// Positive number validation
  static String? validatePositiveNumber(String? value, [String? fieldName]) {
    final numericError = validateNumeric(value, fieldName);
    if (numericError != null) return numericError;

    if (double.parse(value!) <= 0) {
      return '${fieldName ?? 'Field'} must be greater than 0';
    }

    return null;
  }

  /// URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    const pattern = r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Enter a valid URL';
    }

    return null;
  }

  /// Date validation
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }

    try {
      DateTime.parse(value);
    } catch (e) {
      return 'Enter a valid date (YYYY-MM-DD)';
    }

    return null;
  }

  /// Future date validation
  static String? validateFutureDate(String? value) {
    final dateError = validateDate(value);
    if (dateError != null) return dateError;

    final date = DateTime.parse(value!);
    if (date.isBefore(DateTime.now())) {
      return 'Date must be in the future';
    }

    return null;
  }

  /// Credit card validation using Luhn algorithm
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }

    // Remove all non-digit characters
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleaned.length < 13 || cleaned.length > 19) {
      return 'Enter a valid credit card number';
    }

    // Luhn algorithm
    int sum = 0;
    bool alternate = false;
    for (int i = cleaned.length - 1; i >= 0; i--) {
      int digit = int.parse(cleaned[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      sum += digit;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return 'Enter a valid credit card number';
    }

    return null;
  }

  /// Validate OTP code
  static String? validateOtp(String? value, [int length = 6]) {
    if (value == null || value.isEmpty) {
      return 'OTP code is required';
    }

    if (value.length != length || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must be $length digits';
    }

    return null;
  }

  /// Validate checkbox (must be checked)
  static String? validateCheckbox(bool? value, [String? fieldName]) {
    if (value == null || !value) {
      return 'You must accept ${fieldName ?? 'the terms'}';
    }

    return null;
  }

  /// Validate dropdown selection
  static String? validateDropdown(dynamic value, [String? fieldName]) {
    if (value == null) {
      return 'Please select ${fieldName ?? 'an option'}';
    }

    return null;
  }

  /// Validate multiple fields together
  static String? validateMultiple(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) return error;
    }
    return null;
  }
}