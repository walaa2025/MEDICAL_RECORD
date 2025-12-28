/// API constants for medical records backend
/// Base URL: https://localhost:7164
class ApiConstants {
  // Base URL for the API
  static const String baseUrl = 'https://localhost:7164/api';

  // ========== Auth Endpoints ==========
  static const String registerPatient = '$baseUrl/Auth/register/patient';
  static const String registerDoctor = '$baseUrl/Auth/register/doctor';
  static const String registerPharmacist = '$baseUrl/Auth/register/pharmacist';
  static const String login = '$baseUrl/Auth/login';
  static const String logout = '$baseUrl/Auth/logout';
  static const String changePassword = '$baseUrl/Auth/change-password';

  // ========== Patient Endpoints ==========
  static const String patientInitializeProfile = '$baseUrl/Patient/initialize-profile';
  static const String patientProfile = '$baseUrl/Patient/profile';
  static const String patientGenerateQr = '$baseUrl/Patient/generate-qr';
  static const String patientEmergencyScreen = '$baseUrl/Patient/emergency-screen';
  static const String patientMedicalRecords = '$baseUrl/Patient/medical-records';
  static const String patientPrescriptions = '$baseUrl/Patient/prescriptions';

  // ========== Doctor Endpoints ==========
  static const String doctorProfile = '$baseUrl/Doctor/profile';
  static const String doctorSearchPatient = '$baseUrl/Doctor/search-patient';
  static const String doctorMedicalRecord = '$baseUrl/Doctor/medical-record';
  static const String doctorAddPrescription = '$baseUrl/Doctor/AddPrescription';

  // ========== Pharmacist Endpoints ==========
  static const String pharmacistProfile = '$baseUrl/Pharmacist/profile';
  static const String pharmacistSearchPrescription = '$baseUrl/Pharmacist/search-prescription';
  static const String pharmacistCheckDrugInteractions = '$baseUrl/Pharmacist/check-drug-interactions';
  static const String pharmacistDispensePrescription = '$baseUrl/Pharmacist/dispense-prescription';
  static const String pharmacistCreatePrescription = '$baseUrl/Pharmacist/create';
  static const String pharmacistPrescriptionStatus = '$baseUrl/Pharmacist/prescription-status';

  // ========== Headers ==========
  /// Default headers for all requests
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Headers with authentication token
  /// Use this for authenticated requests
  static Map<String, String> headersWithAuth(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
