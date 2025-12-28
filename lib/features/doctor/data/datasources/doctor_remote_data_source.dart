import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:midical_record/core/constants/api_constants.dart';
import 'package:midical_record/features/doctor/data/models/doctor_models.dart';

/// Remote data source for doctor operations
class DoctorRemoteDataSource {
  
  // ========== Get Profile ==========
  
  /// Get doctor profile information
  Future<DoctorProfileModel> getProfile(String token) async {
    final url = Uri.parse(ApiConstants.doctorProfile);
    
    try {
      final response = await http.get(
        url,
        headers: ApiConstants.headersWithAuth(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DoctorProfileModel.fromJson(data['doctor']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get profile');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ========== Update Profile ==========
  
  /// Update doctor profile
  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required DoctorProfileModel profile,
  }) async {
    final url = Uri.parse(ApiConstants.doctorProfile);
    
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

  // ========== Search Patient ==========
  
  /// Search for a patient by national ID or patient code
  Future<PatientSearchResultModel> searchPatient({
    required String token,
    required String identifier,
  }) async {
    final url = Uri.parse(ApiConstants.doctorSearchPatient);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode({'identifier': identifier}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PatientSearchResultModel.fromJson(data['patient']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Patient not found');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ========== Get Patient Full Medical Record ==========
  
  /// Get complete patient medical record (for viewing)
  Future<PatientSearchResultModel> getPatientFullRecord({
    required String token,
    required String identifier,
  }) async {
    // Both search and get record use the same logic/endpoint now as per requirements
    return searchPatient(token: token, identifier: identifier);
  }

  // ========== Add Medical Record ==========
  
  /// Add a new medical record (diagnosis/notes) for a patient
  Future<Map<String, dynamic>> addMedicalRecord({
    required String token,
    required AddMedicalRecordModel record,
  }) async {
    final url = Uri.parse(ApiConstants.doctorMedicalRecord);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode(record.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to add medical record');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ========== Create Prescription ==========
  
  /// Create a new prescription for a patient
  Future<Map<String, dynamic>> createPrescription({
    required String token,
    required AddPrescriptionModel prescription,
  }) async {
    final url = Uri.parse(ApiConstants.doctorAddPrescription);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode(prescription.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to create prescription');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}
