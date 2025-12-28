import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midical_record/features/patient/data/datasources/patient_remote_data_source.dart';
import 'package:midical_record/features/patient/data/models/patient_models.dart';

// ========== DATA SOURCE PROVIDER ==========

/// Provider for patient remote data source
final patientRemoteDataSourceProvider = Provider<PatientRemoteDataSource>((ref) {
  return PatientRemoteDataSource();
});

// ========== PATIENT PROFILE PROVIDERS ==========

/// Patient Profile Provider
class PatientProfileNotifier extends AsyncNotifier<PatientProfileModel?> {
  @override
  FutureOr<PatientProfileModel?> build() {
    return null; // Initial state
  }

  /// Load patient profile
  Future<void> loadProfile(String token) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(patientRemoteDataSourceProvider);
      final profile = await dataSource.getProfile(token);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Initialize profile (first time)
  Future<void> initializeProfile(String token, PatientInitializationModel profile) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(patientRemoteDataSourceProvider);
      await dataSource.initializeProfile(token: token, profile: profile);
      // We don't set state directly here because InitModel != ProfileModel (GET).
      // Ideally we reload profile after Init.
      await loadProfile(token);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Update profile
  Future<void> updateProfile(String token, PatientInitializationModel profile) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(patientRemoteDataSourceProvider);
      await dataSource.updateProfile(token: token, profile: profile);
      // Reload profile to get fresh data
      await loadProfile(token);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final patientProfileProvider = AsyncNotifierProvider<PatientProfileNotifier, PatientProfileModel?>(() {
  return PatientProfileNotifier();
});

// ========== QR CODE PROVIDER ==========

/// QR Code Provider
class PatientQrNotifier extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() {
    return null;
  }

  /// Generate QR code
  Future<void> generateQr(String token) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(patientRemoteDataSourceProvider);
      final qrCode = await dataSource.generateQrCode(token);
      state = AsyncValue.data(qrCode);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final patientQrProvider = AsyncNotifierProvider<PatientQrNotifier, String?>(() {
  return PatientQrNotifier();
});

// ========== EMERGENCY DATA PROVIDER ==========

/// Emergency Data Provider
class EmergencyDataNotifier extends AsyncNotifier<EmergencyDataModel?> {
  @override
  FutureOr<EmergencyDataModel?> build() {
    return null;
  }

  /// Load emergency data
  Future<void> loadEmergencyData(String token) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(patientRemoteDataSourceProvider);
      final data = await dataSource.getEmergencyData(token);
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final emergencyDataProvider = AsyncNotifierProvider<EmergencyDataNotifier, EmergencyDataModel?>(() {
  return EmergencyDataNotifier();
});

// ========== MEDICAL RECORDS PROVIDER ==========

/// Medical Records Provider
class MedicalRecordsNotifier extends AsyncNotifier<List<MedicalRecordModel>> {
  @override
  FutureOr<List<MedicalRecordModel>> build() {
    return [];
  }

  /// Load medical records
  Future<void> loadRecords(String token) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(patientRemoteDataSourceProvider);
      final records = await dataSource.getMedicalRecords(token);
      state = AsyncValue.data(records);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final medicalRecordsProvider = AsyncNotifierProvider<MedicalRecordsNotifier, List<MedicalRecordModel>>(() {
  return MedicalRecordsNotifier();
});

// ========== PRESCRIPTIONS PROVIDER ==========

/// Prescriptions Provider
class PrescriptionsNotifier extends AsyncNotifier<List<PrescriptionModel>> {
  @override
  FutureOr<List<PrescriptionModel>> build() {
    return [];
  }

  /// Load prescriptions
  Future<void> loadPrescriptions(String token) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(patientRemoteDataSourceProvider);
      final prescriptions = await dataSource.getPrescriptions(token);
      state = AsyncValue.data(prescriptions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final prescriptionsProvider = AsyncNotifierProvider<PrescriptionsNotifier, List<PrescriptionModel>>(() {
  return PrescriptionsNotifier();
});
