import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midical_record/features/doctor/data/datasources/doctor_remote_data_source.dart';
import 'package:midical_record/features/doctor/data/models/doctor_models.dart';

// ========== DATA SOURCE PROVIDER ==========

final doctorRemoteDataSourceProvider = Provider<DoctorRemoteDataSource>((ref) {
  return DoctorRemoteDataSource();
});

// ========== DOCTOR PROFILE PROVIDER ==========

class DoctorProfileNotifier extends AsyncNotifier<DoctorProfileModel?> {
  @override
  FutureOr<DoctorProfileModel?> build() {
    return null;
  }

  Future<void> loadProfile(String token) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(doctorRemoteDataSourceProvider);
      final profile = await dataSource.getProfile(token);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile(String token, DoctorProfileModel profile) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(doctorRemoteDataSourceProvider);
      await dataSource.updateProfile(token: token, profile: profile);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final doctorProfileProvider = AsyncNotifierProvider<DoctorProfileNotifier, DoctorProfileModel?>(() {
  return DoctorProfileNotifier();
});

// ========== PATIENT SEARCH PROVIDER ==========

class PatientSearchNotifier extends AsyncNotifier<PatientSearchResultModel?> {
  @override
  FutureOr<PatientSearchResultModel?> build() {
    return null;
  }

  Future<void> searchPatient(String token, String identifier) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(doctorRemoteDataSourceProvider);
      final result = await dataSource.searchPatient(token: token, identifier: identifier);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

final patientSearchProvider = AsyncNotifierProvider<PatientSearchNotifier, PatientSearchResultModel?>(() {
  return PatientSearchNotifier();
});

// ========== PATIENT FULL RECORD PROVIDER ==========

class PatientFullRecordNotifier extends AsyncNotifier<PatientSearchResultModel?> {
  @override
  FutureOr<PatientSearchResultModel?> build() {
    return null;
  }

  Future<void> loadPatientRecord(String token, String identifier) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(doctorRemoteDataSourceProvider);
      final record = await dataSource.getPatientFullRecord(token: token, identifier: identifier);
      state = AsyncValue.data(record);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

final patientFullRecordProvider = AsyncNotifierProvider<PatientFullRecordNotifier, PatientSearchResultModel?>(() {
  return PatientFullRecordNotifier();
});

// ========== ADD MEDICAL RECORD PROVIDER ==========

class AddMedicalRecordNotifier extends AsyncNotifier<Map<String, dynamic>?> {
  @override
  FutureOr<Map<String, dynamic>?> build() {
    return null;
  }

  Future<void> addRecord(String token, AddMedicalRecordModel record) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(doctorRemoteDataSourceProvider);
      final result = await dataSource.addMedicalRecord(token: token, record: record);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final addMedicalRecordProvider = AsyncNotifierProvider<AddMedicalRecordNotifier, Map<String, dynamic>?>(() {
  return AddMedicalRecordNotifier();
});

// ========== CREATE PRESCRIPTION PROVIDER ==========

class CreatePrescriptionNotifier extends AsyncNotifier<Map<String, dynamic>?> {
  @override
  FutureOr<Map<String, dynamic>?> build() {
    return null;
  }

  Future<void> createPrescription(String token, AddPrescriptionModel prescription) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(doctorRemoteDataSourceProvider);
      final result = await dataSource.createPrescription(token: token, prescription: prescription);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final createPrescriptionProvider = AsyncNotifierProvider<CreatePrescriptionNotifier, Map<String, dynamic>?>(() {
  return CreatePrescriptionNotifier();
});
