import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:midical_record/core/constants/api_constants.dart';
import 'package:midical_record/features/pharmacist/data/models/pharmacist_models.dart';

/// Remote data source for pharmacist operations
class PharmacistRemoteDataSource {
  
  /// Get pharmacist profile
  Future<PharmacistProfileModel> getProfile(String token) async {
    final url = Uri.parse(ApiConstants.pharmacistProfile);
    
    try {
      final response = await http.get(
        url,
        headers: ApiConstants.headersWithAuth(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PharmacistProfileModel.fromJson(data['pharmacist']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get profile');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  /// Update pharmacist profile
  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required PharmacistProfileModel profile,
  }) async {
    final url = Uri.parse(ApiConstants.pharmacistProfile);
    
    try {
      final response = await http.put(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode(profile.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Profile update failed');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  /// Search prescription by patient identifier
  Future<List<PrescriptionSearchResultModel>> searchPrescription({
    required String token,
    required String identifier,
  }) async {
    final url = Uri.parse(ApiConstants.pharmacistSearchPrescription);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode({'identifier': identifier}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List prescriptionsList = data['prescriptions'] ?? [];
        return prescriptionsList.map((p) => PrescriptionSearchResultModel.fromJson(p)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'No prescriptions found');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  /// Check drug interactions
  Future<List<DrugInteractionModel>> checkDrugInteractions({
    required String token,
    required List<String> medications,
  }) async {
    final url = Uri.parse(ApiConstants.pharmacistCheckDrugInteractions);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode({'medications': medications}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List interactionsList = data['warnings'] ?? [];
        return interactionsList.map((i) => DrugInteractionModel.fromJson(i)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to check interactions');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  /// Dispense prescription
  Future<Map<String, dynamic>> dispensePrescription({
    required String token,
    required DispensePrescriptionModel dispense,
  }) async {
    final url = Uri.parse(ApiConstants.pharmacistDispensePrescription);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode(dispense.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to dispense prescription');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  /// Create extra prescription items
  Future<Map<String, dynamic>> createExtraMedication({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    final url = Uri.parse(ApiConstants.pharmacistCreatePrescription);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to create extra item');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  /// Update prescription status
  Future<Map<String, dynamic>> updatePrescriptionStatus({
    required String token,
    required int prescriptionId,
    required int status,
    String? notes,
  }) async {
    final url = Uri.parse(ApiConstants.pharmacistPrescriptionStatus);
    
    try {
      final response = await http.put(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode({
          'prescriptionId': prescriptionId,
          'status': status,
          'notes': notes,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update status');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}
