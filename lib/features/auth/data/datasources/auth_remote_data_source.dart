import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:midical_record/features/auth/data/models/auth_model.dart';
import 'package:midical_record/features/auth/data/models/doctor_model.dart';
import 'package:midical_record/core/constants/api_constants.dart';

/// Remote data source for authentication operations
/// Handles all API calls related to auth (login, register, logout, change password)
class AuthRemoteDataSource {
  
  // ========== Login ==========
  
  /// Login with identifier (nationalId or patient code) and password
  /// Returns LoginResponseModel with accessToken, role, and userId
  Future<LoginResponseModel> login({
    required String identifier,
    required String password,
    String? deviceToken,
    String? devicePlatform,
  }) async {
    final url = Uri.parse(ApiConstants.login);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
          if (deviceToken != null) 'deviceToken': deviceToken,
          if (devicePlatform != null) 'devicePlatform': devicePlatform,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponseModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error during login: $e');
    }
  }

  // ========== Register Patient ==========
  
  /// Register a new patient (simplified fields)
  /// Returns PatientRegistrationResponseModel with auto-generated patient code
  Future<PatientRegistrationResponseModel> registerPatient(
    PatientRegistrationModel patient,
  ) async {
    final url = Uri.parse(ApiConstants.registerPatient);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: jsonEncode(patient.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return PatientRegistrationResponseModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error during patient registration: $e');
    }
  }

  // ========== Register Doctor ==========
  
  /// Register a new doctor (requires admin approval)
  /// Returns DoctorRegistrationResponseModel with pending approval message
  Future<DoctorRegistrationResponseModel> registerDoctor(
    DoctorModel doctor,
  ) async {
    final url = Uri.parse(ApiConstants.registerDoctor);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: jsonEncode(doctor.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return DoctorRegistrationResponseModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Doctor registration failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error during doctor registration: $e');
    }
  }

  // ========== Register Pharmacist ==========
  
  /// Register a new pharmacist (requires admin approval)
  /// Returns PharmacistRegistrationResponseModel with pending approval message
  Future<PharmacistRegistrationResponseModel> registerPharmacist({
    required String nationalId,
    required String password,
    required String confirmPassword,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String licenseNumber,
    required String licenseDocumentUrl,
    required String pharmacyName,
  }) async {
    final url = Uri.parse(ApiConstants.registerPharmacist);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: jsonEncode({
          'nationalId': nationalId,
          'password': password,
          'confirmPassword': confirmPassword,
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'licenseNumber': licenseNumber,
          'licenseDocumentUrl': licenseDocumentUrl,
          'pharmacyName': pharmacyName,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return PharmacistRegistrationResponseModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Pharmacist registration failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error during pharmacist registration: $e');
    }
  }

  // ========== Logout ==========
  
  /// Logout the current user
  /// Requires authentication token
  Future<ApiResponseModel> logout(String token) async {
    final url = Uri.parse(ApiConstants.logout);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headersWithAuth(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponseModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Logout failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error during logout: $e');
    }
  }

  // ========== Change Password ==========
  
  /// Change the current user's password
  /// Requires authentication token
  Future<ApiResponseModel> changePassword({
    required String token,
    required ChangePasswordModel passwordData,
  }) async {
    final url = Uri.parse(ApiConstants.changePassword);
    
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.headersWithAuth(token),
        body: jsonEncode(passwordData.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponseModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Password change failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error during password change: $e');
    }
  }
}
