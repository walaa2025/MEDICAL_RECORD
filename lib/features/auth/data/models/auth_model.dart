import 'package:midical_record/features/auth/domain/entities/auth_entity.dart';
import 'package:midical_record/core/constants/app_enums.dart';

// ========== Login Response Model ==========

/// Model for login API response
/// Matches: { "success": true, "accessToken": "arO4ui05WDw", "role": "Patient", "userId": 105 }
class LoginResponseModel {
  final bool success;
  final String accessToken;
  final String role; // "Patient", "Doctor", "Pharmacist", "Admin"
  final int userId;

  LoginResponseModel({
    required this.success,
    required this.accessToken,
    required this.role,
    required this.userId,
  });

  /// Create from JSON response
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      accessToken: json['accessToken'] ?? '',
      role: json['role'] ?? 'Patient',
      userId: json['userId'] ?? 0,
    );
  }

  /// Get user role enum from string
  UserRole get userRoleEnum {
    switch (role.toLowerCase()) {
      case 'patient':
        return UserRole.patient;
      case 'doctor':
        return UserRole.doctor;
      case 'pharmacist':
        return UserRole.pharmacist;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.patient;
    }
  }
}

// ========== Patient Registration Response Model ==========

/// Model for patient registration API response
/// Matches: { "success": true, "message": "...", "data": { "patientCode": "PM-37294128", "userId": 106 } }
class PatientRegistrationResponseModel {
  final bool success;
  final String message;
  final String? patientCode;
  final int? userId;

  PatientRegistrationResponseModel({
    required this.success,
    required this.message,
    this.patientCode,
    this.userId,
  });

  /// Create from JSON response
  factory PatientRegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return PatientRegistrationResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      patientCode: json['data']?['patientCode'],
      userId: json['data']?['userId'],
    );
  }
}

// ========== Patient Registration Request Model ==========

/// Model for patient registration request (simplified fields)
/// Required: nationalId, password, confirmPassword, fullName
/// Optional: dateOfBirth (defaults to current date), phoneNumber, email
class PatientRegistrationModel {
  final String nationalId;
  final String password;
  final String confirmPassword;
  final String fullName;
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final String? email;

  PatientRegistrationModel({
    required this.nationalId,
    required this.password,
    required this.confirmPassword,
    required this.fullName,
    this.dateOfBirth,
    this.phoneNumber,
    this.email,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'nationalId': nationalId,
      'password': password,
      'confirmPassword': confirmPassword,
      'fullName': fullName,
      'dateOfBirth': (dateOfBirth ?? DateTime.now()).toIso8601String(),
      'phoneNumber': phoneNumber ?? '',
      'email': email ?? '',
    };
  }
}

// ========== Doctor Registration Request Model ==========

/// Model for doctor registration request
/// Required: nationalId, password, confirmPassword, fullName, licenseNumber
/// Optional: email, phoneNumber, licenseDocumentUrl, specialization, hospital
class DoctorRegistrationModel {
  final String nationalId;
  final String password;
  final String confirmPassword;
  final String fullName;
  final String? email;
  final String? phoneNumber;
  final String licenseNumber;
  final String? licenseDocumentUrl;
  final String? specialization;
  final String? hospital;

  DoctorRegistrationModel({
    required this.nationalId,
    required this.password,
    required this.confirmPassword,
    required this.fullName,
    this.email,
    this.phoneNumber,
    required this.licenseNumber,
    this.licenseDocumentUrl,
    this.specialization,
    this.hospital,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'nationalId': nationalId,
      'password': password,
      'confirmPassword': confirmPassword,
      'fullName': fullName,
      'email': email ?? '',
      'phoneNumber': phoneNumber ?? '',
      'licenseNumber': licenseNumber,
      'licenseDocumentUrl': licenseDocumentUrl ?? '',
      'specialization': specialization ?? '',
      'hospital': hospital ?? '',
    };
  }
}

// ========== Doctor Registration Response Model ==========

/// Model for doctor registration API response
/// Matches: { "success": true, "message": "Doctor registration submitted (pending approval)", "data": null }
class DoctorRegistrationResponseModel {
  final bool success;
  final String message;

  DoctorRegistrationResponseModel({
    required this.success,
    required this.message,
  });

  /// Create from JSON response
  factory DoctorRegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorRegistrationResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

// ========== Pharmacist Registration Request Model ==========

/// Model for pharmacist registration request
/// Required: nationalId, password, confirmPassword, fullName, licenseNumber
/// Optional: email, phoneNumber, licenseDocumentUrl, pharmacyName
class PharmacistRegistrationModel {
  final String nationalId;
  final String password;
  final String confirmPassword;
  final String fullName;
  final String? email;
  final String? phoneNumber;
  final String licenseNumber;
  final String? licenseDocumentUrl;
  final String? pharmacyName;

  PharmacistRegistrationModel({
    required this.nationalId,
    required this.password,
    required this.confirmPassword,
    required this.fullName,
    this.email,
    this.phoneNumber,
    required this.licenseNumber,
    this.licenseDocumentUrl,
    this.pharmacyName,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'nationalId': nationalId,
      'password': password,
      'confirmPassword': confirmPassword,
      'fullName': fullName,
      'email': email ?? '',
      'phoneNumber': phoneNumber ?? '',
      'licenseNumber': licenseNumber,
      'licenseDocumentUrl': licenseDocumentUrl ?? '',
      'pharmacyName': pharmacyName ?? '',
    };
  }
}

// ========== Pharmacist Registration Response Model ==========

/// Model for pharmacist registration API response
/// Matches: { "success": true, "message": "Pharmacist registration submitted (pending approval)", "data": null }
class PharmacistRegistrationResponseModel {
  final bool success;
  final String message;

  PharmacistRegistrationResponseModel({
    required this.success,
    required this.message,
  });

  /// Create from JSON response
  factory PharmacistRegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return PharmacistRegistrationResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

// ========== Change Password Request Model ==========

/// Model for change password request
class ChangePasswordModel {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordModel({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    };
  }
}

// ========== API Response Wrapper ==========

/// Generic API response wrapper
/// Used for endpoints that return { "success": bool, "message": string }
class ApiResponseModel {
  final bool success;
  final String message;

  ApiResponseModel({
    required this.success,
    required this.message,
  });

  /// Create from JSON response
  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

// ========== LEGACY MODELS (Deprecated) ==========

/// These models are kept for backward compatibility with existing screens
/// New code should use the models above

class AuthModel extends AuthEntity {
  AuthModel({
    required String userId,
    required String nationalId,
    required String token,
  }) : super(
          userId: userId,
          nationalId: nationalId,
          token: token,
        );

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      userId: json['userId'].toString(),
      nationalId: json['nationalId'] ?? '',
      token: json['token'] ?? '',
    );
  }

  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(
      userId: entity.userId,
      nationalId: entity.nationalId,
      token: entity.token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nationalId': nationalId,
      'token': token,
    };
  }
}

// ========== Patient Model ==========

/// Model for Patient Entity
class PatientModel extends PatientEntity {
  PatientModel({
    required super.id,
    required super.name,
    required super.age,
    required super.dateOfBirth,
    required super.gender,
    required super.bloodType,
    required super.height,
    required super.weight,
    required super.chronicDiseases,
    required super.currentMedications,
    required super.allergies,
    required super.surgicalOperations,
    required super.attendingDoctor,
    required super.emergencyNumber,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] ?? DateTime.now().toIso8601String()),
      gender: json['gender'] ?? '',
      bloodType: json['bloodType'] ?? '',
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      chronicDiseases: json['chronicDiseases'] ?? '',
      currentMedications: json['currentMedications'] ?? '',
      allergies: json['allergies'] ?? '',
      surgicalOperations: json['surgicalOperations'] ?? '',
      attendingDoctor: json['attendingDoctor'] ?? '',
      emergencyNumber: json['emergencyNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'bloodType': bloodType,
      'height': height,
      'weight': weight,
      'chronicDiseases': chronicDiseases,
      'currentMedications': currentMedications,
      'allergies': allergies,
      'surgicalOperations': surgicalOperations,
      'attendingDoctor': attendingDoctor,
      'emergencyNumber': emergencyNumber,
    };
  }

  factory PatientModel.fromEntity(PatientEntity entity) {
    return PatientModel(
      id: entity.id,
      name: entity.name,
      age: entity.age,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      bloodType: entity.bloodType,
      height: entity.height,
      weight: entity.weight,
      chronicDiseases: entity.chronicDiseases,
      currentMedications: entity.currentMedications,
      allergies: entity.allergies,
      surgicalOperations: entity.surgicalOperations,
      attendingDoctor: entity.attendingDoctor,
      emergencyNumber: entity.emergencyNumber,
    );
  }
}
