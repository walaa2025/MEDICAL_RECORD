/// Validation utilities for form fields
class ValidationUtils {
  /// Validate email format
  static String? validateEmail(String? value, {required String requiredMessage, required String invalidMessage}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    
    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address (e.g., user@example.com)';
    }
    return null;
  }

  /// Validate required email
  static String? validateRequiredEmail(String? value, {required String requiredMessage, required String invalidMessage}) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage;
    }
    return validateEmail(value, requiredMessage: requiredMessage, invalidMessage: invalidMessage);
  }

  /// Validate phone number (Yemen local format: 9 digits starting with 7x)
  static String? validatePhone(String? value, {required String invalidMessage}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    
    // Remove spaces, dashes, and leading zero/967
    String cleaned = value.replaceAll(RegExp(r'[\s-+]'), '');
    if (cleaned.startsWith('967')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }
    
    // Yemen mobile format: 9 digits starting with 77, 73, 71, or 70
    final yemenPhoneRegex = RegExp(r'^(77|73|71|70)\d{7}$');
    
    if (!yemenPhoneRegex.hasMatch(cleaned)) {
      return 'Please enter a valid Yemen phone number (9 digits starting with 77, 73, 71, or 70)';
    }
    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value, {
    required String requiredMessage,
    required String tooShortMessage,
    required String weakMessage,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMessage;
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    // Check for at least one uppercase, one lowercase, and one number
    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'[0-9]'));
    
    if (!hasUppercase) {
      return 'Password must contain at least one uppercase letter (A-Z)';
    }
    
    if (!hasLowercase) {
      return 'Password must contain at least one lowercase letter (a-z)';
    }
    
    if (!hasDigit) {
      return 'Password must contain at least one number (0-9)';
    }
    
    return null;
  }

  /// Validate national ID (Yemen format: 11 digits)
  static String? validateNationalId(String? value, {
    required String requiredMessage,
    required String invalidMessage,
    int length = 11,
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage;
    }
    
    final cleaned = value.trim();
    
    // Check if it's all digits
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return 'National ID must contain only numbers';
    }
    
    // Yemen National ID is 11 digits
    if (cleaned.length != length) {
      return 'Yemen National ID must be exactly $length digits';
    }
    
    return null;
  }

  /// Validate license number (for doctors and pharmacists)
  static String? validateLicenseNumber(String? value, {
    required String requiredMessage,
    int minLength = 5,
    int maxLength = 20,
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage;
    }
    
    final cleaned = value.trim();
    
    // Check if it contains only alphanumeric characters
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(cleaned)) {
      return 'License number must contain only letters and numbers';
    }
    
    // Check length
    if (cleaned.length < minLength) {
      return 'License number must be at least $minLength characters';
    }
    
    if (cleaned.length > maxLength) {
      return 'License number cannot exceed $maxLength characters';
    }
    
    return null;
  }

  /// Validate numeric value within range
  static String? validateNumericRange(String? value, {
    required String invalidMessage,
    double? min,
    double? max,
  }) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    
    final number = double.tryParse(value.trim());
    if (number == null) {
      return invalidMessage;
    }
    
    if (min != null && number < min) {
      return '$invalidMessage (min: $min)';
    }
    
    if (max != null && number > max) {
      return '$invalidMessage (max: $max)';
    }
    
    return null;
  }

  /// Validate date is in the past
  static String? validatePastDate(DateTime? date, {required String invalidMessage}) {
    if (date == null) {
      return null; // Optional field
    }
    
    if (date.isAfter(DateTime.now())) {
      return invalidMessage;
    }
    
    return null;
  }

  /// Validate date is not too far in the past (e.g., for date of birth)
  static String? validateDateOfBirth(DateTime? date, {
    required String requiredMessage,
    required String invalidMessage,
    int maxYearsAgo = 150,
  }) {
    if (date == null) {
      return null; // Optional in some cases
    }
    
    final now = DateTime.now();
    final minDate = DateTime(now.year - maxYearsAgo, now.month, now.day);
    
    if (date.isAfter(now)) {
      return invalidMessage;
    }
    
    if (date.isBefore(minDate)) {
      return '$invalidMessage (too old)';
    }
    
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {required String requiredMessage}) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage;
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, {
    required int minLength,
    required String message,
  }) {
    if (value == null || value.trim().isEmpty) {
      return null; // Handle required separately
    }
    
    if (value.trim().length < minLength) {
      return message;
    }
    return null;
  }

  /// Validate password confirmation
  static String? validatePasswordMatch(String? value, String? originalPassword, {
    required String requiredMessage,
    required String mismatchMessage,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMessage;
    }
    
    if (value != originalPassword) {
      return mismatchMessage;
    }
    
    return null;
  }
}
