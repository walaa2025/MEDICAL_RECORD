import 'package:midical_record/l10n/app_localizations.dart';

/// Enums matching the medical records API specification
/// These values must match the backend numeric values exactly

/// User role types (used for routing after login, NOT for role management)
/// Role management is handled by web admin panel
enum UserRole {
  patient(1),
  doctor(2),
  pharmacist(3),
  admin(4); // Only for parsing API responses, no admin features in mobile app

  final int value;
  const UserRole(this.value);

  /// Create UserRole from API numeric value
  static UserRole fromValue(int value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.patient,
    );
  }
}

/// Gender types
enum Gender {
  male(1),
  female(2);

  final int value;
  const Gender(this.value);

  /// Create Gender from API numeric value
  static Gender fromValue(int value) {
    return Gender.values.firstWhere(
      (gender) => gender.value == value,
      orElse: () => Gender.male,
    );
  }

  /// Get display name in Arabic
  String get displayNameAr {
    switch (this) {
      case Gender.male:
        return 'ذكر';
      case Gender.female:
        return 'أنثى';
    }
  }

  /// Get display name in English
  String get displayNameEn {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }

  /// Get display name (defaults to Arabic)
  String get displayName => displayNameAr;

  /// Get localized name
  String getLocalizedName(AppLocalizations l10n) {
    switch (this) {
      case Gender.male: return l10n.male;
      case Gender.female: return l10n.female;
    }
  }
}

// Ensure AppLocalizations is imported

/// Blood type categories
enum BloodType {
  aPositive(1, 'A+'),
  aNegative(2, 'A-'),
  bPositive(3, 'B+'),
  bNegative(4, 'B-'),
  abPositive(5, 'AB+'),
  abNegative(6, 'AB-'),
  oPositive(7, 'O+'),
  oNegative(8, 'O-');

  final int value;
  final String displayName;
  const BloodType(this.value, this.displayName);

  /// Create BloodType from API numeric value
  static BloodType fromValue(int value) {
    return BloodType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => BloodType.oPositive,
    );
  }
}

/// User account status
enum UserStatus {
  pending(1),
  active(2),
  suspended(3);

  final int value;
  const UserStatus(this.value);

  /// Create UserStatus from API numeric value
  static UserStatus fromValue(int value) {
    return UserStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => UserStatus.pending,
    );
  }

  /// Get display name in Arabic
  String get displayNameAr {
    switch (this) {
      case UserStatus.pending:
        return 'قيد الانتظار';
      case UserStatus.active:
        return 'نشط';
      case UserStatus.suspended:
        return 'معلق';
    }
  }

  /// Get display name in English
  String get displayNameEn {
    switch (this) {
      case UserStatus.pending:
        return 'Pending';
      case UserStatus.active:
        return 'Active';
      case UserStatus.suspended:
        return 'Suspended';
    }
  }
}

/// Prescription status
enum PrescriptionStatus {
  pending(1),
  partiallyDispensed(2),
  fullyDispensed(3),
  cancelled(4);

  final int value;
  const PrescriptionStatus(this.value);

  /// Create PrescriptionStatus from API numeric value
  static PrescriptionStatus fromValue(int value) {
    return PrescriptionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PrescriptionStatus.pending,
    );
  }

  /// Get display name in Arabic
  String get displayNameAr {
    switch (this) {
      case PrescriptionStatus.pending:
        return 'قيد الانتظار';
      case PrescriptionStatus.partiallyDispensed:
        return 'تم الصرف جزئياً';
      case PrescriptionStatus.fullyDispensed:
        return 'تم الصرف بالكامل';
      case PrescriptionStatus.cancelled:
        return 'ملغي';
    }
  }

  /// Get display name in English
  String get displayNameEn {
    switch (this) {
      case PrescriptionStatus.pending:
        return 'Pending';
      case PrescriptionStatus.partiallyDispensed:
        return 'Partially Dispensed';
      case PrescriptionStatus.fullyDispensed:
        return 'Fully Dispensed';
      case PrescriptionStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get localized name
  String getLocalizedName(AppLocalizations l10n) {
    switch (this) {
      case PrescriptionStatus.pending: return l10n.pending;
      case PrescriptionStatus.partiallyDispensed: return l10n.partiallyDispensed;
      case PrescriptionStatus.fullyDispensed: return l10n.fullyDispensed;
      case PrescriptionStatus.cancelled: return l10n.cancelled;
    }
  }
}
