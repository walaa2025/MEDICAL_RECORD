import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:midical_record/core/constants/api_constants.dart';
import 'package:midical_record/features/patient/data/models/patient_models.dart';

/// Remote data source for patient operations
/// Handles all API calls related to patient endpoints
class PatientRemoteDataSource {
  
  // ========== Initialize Profile ==========
  
  /// Initialize patient profile with complete medical information
  /// Called after first registration to complete profile
  Future<Map<String, dynamic>> initializeProfile({
    required String token,
    required PatientInitializationModel profile,
  }) async {
    final url = Uri.parse(ApiConstants.patientInitializeProfile);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode(profile.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Profile initialization failed');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ========== Get Profile ==========
  
  /// Get patient profile information
  Future<PatientProfileModel> getProfile(String token) async {
    final url = Uri.parse(ApiConstants.patientProfile);
    
    try {
      final response = await http.get(
        url,
        headers: ApiConstants.headersWithAuth(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PatientProfileModel.fromJson(data['patient']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get profile');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ========== Update Profile ==========
  
  /// Update patient profile
  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required PatientInitializationModel profile,
  }) async {
    final url = Uri.parse(ApiConstants.patientProfile);
    
    try {
      final response = await http.put(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode(profile.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Profile update failed');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ========== Generate QR Code ==========
  
  /// Generate QR code for patient
  /// Returns base64 encoded QR image or URL
  Future<String> generateQrCode(String token) async {
    final url = Uri.parse(ApiConstants.patientGenerateQr);
    
    try {
      final response = await http.get(
        url,
        headers: ApiConstants.headersWithAuth(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['qrCodeUrl'] ?? '';
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'QR generation failed');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ========== Get Emergency Screen Data ==========
  
  /// Get emergency screen data for display
  Future<EmergencyDataModel> getEmergencyData(String token) async {
    final url = Uri.parse(ApiConstants.patientEmergencyScreen);
    
    try {
      final response = await http.get(
        url,
        headers: ApiConstants.headersWithAuth(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EmergencyDataModel.fromJson(data['emergencyInfo']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get emergency data');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ========== Get Medical Records ==========
  
  /// Get patient's medical records list
  Future<List<MedicalRecordModel>> getMedicalRecords(String token) async {
    final url = Uri.parse(ApiConstants.patientMedicalRecords);
    
    try {
      final response = await http.get(
        url,
        headers: ApiConstants.headersWithAuth(token),
      );

      if (response.statusCode == 200) {
        final List recordsList = jsonDecode(response.body); // Direct list response
        return recordsList.map((record) => MedicalRecordModel.fromJson(record)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get medical records');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ========== Get Prescriptions ==========
  
  /// Get patient's prescriptions list
  Future<List<PrescriptionModel>> getPrescriptions(String token) async {
    final url = Uri.parse(ApiConstants.patientPrescriptions);
    
    try {
      final response = await http.get(
        url,
        headers: ApiConstants.headersWithAuth(token),
      );

      if (response.statusCode == 200) {
        final List prescriptionsList = jsonDecode(response.body); // Direct list response
        return prescriptionsList.map((prescription) => PrescriptionModel.fromJson(prescription)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get prescriptions');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}
