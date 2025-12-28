import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midical_record/features/pharmacist/data/datasources/pharmacist_remote_data_source.dart';
import 'package:midical_record/features/pharmacist/data/models/pharmacist_models.dart';

// Data Source Provider
final pharmacistRemoteDataSourceProvider = Provider<PharmacistRemoteDataSource>((ref) {
  return PharmacistRemoteDataSource();
});

// Pharmacist Profile Provider
class PharmacistProfileNotifier extends AsyncNotifier<PharmacistProfileModel?> {
  @override
  FutureOr<PharmacistProfileModel?> build() => null;

  Future<void> loadProfile(String token) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(pharmacistRemoteDataSourceProvider);
      final profile = await dataSource.getProfile(token);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile(String token, PharmacistProfileModel profile) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(pharmacistRemoteDataSourceProvider);
      await dataSource.updateProfile(token: token, profile: profile);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final pharmacistProfileProvider = AsyncNotifierProvider<PharmacistProfileNotifier, PharmacistProfileModel?>(() {
  return PharmacistProfileNotifier();
});

// Prescription Search Provider
class PrescriptionSearchNotifier extends AsyncNotifier<List<PrescriptionSearchResultModel>> {
  @override
  FutureOr<List<PrescriptionSearchResultModel>> build() => [];

  Future<void> searchPrescriptions(String token, String identifier) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(pharmacistRemoteDataSourceProvider);
      final results = await dataSource.searchPrescription(token: token, identifier: identifier);
      state = AsyncValue.data(results);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

final prescriptionSearchProvider = AsyncNotifierProvider<PrescriptionSearchNotifier, List<PrescriptionSearchResultModel>>(() {
  return PrescriptionSearchNotifier();
});

// Drug Interactions Provider
class DrugInteractionsNotifier extends AsyncNotifier<List<DrugInteractionModel>> {
  @override
  FutureOr<List<DrugInteractionModel>> build() => [];

  Future<void> checkInteractions(String token, List<String> medications) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(pharmacistRemoteDataSourceProvider);
      final interactions = await dataSource.checkDrugInteractions(token: token, medications: medications);
      state = AsyncValue.data(interactions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

final drugInteractionsProvider = AsyncNotifierProvider<DrugInteractionsNotifier, List<DrugInteractionModel>>(() {
  return DrugInteractionsNotifier();
});

// Dispense Prescription Provider
class DispensePrescriptionNotifier extends AsyncNotifier<Map<String, dynamic>?> {
  @override
  FutureOr<Map<String, dynamic>?> build() => null;

  Future<void> dispense(String token, DispensePrescriptionModel model) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(pharmacistRemoteDataSourceProvider);
      final result = await dataSource.dispensePrescription(token: token, dispense: model);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final dispensePrescriptionProvider = AsyncNotifierProvider<DispensePrescriptionNotifier, Map<String, dynamic>?>(() {
  return DispensePrescriptionNotifier();
});

// ========== CREATE EXTRA MEDICATION PROVIDER ==========

class CreateExtraMedicationNotifier extends AsyncNotifier<Map<String, dynamic>?> {
  @override
  FutureOr<Map<String, dynamic>?> build() => null;

  Future<void> createExtraMedication(String token, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(pharmacistRemoteDataSourceProvider);
      final result = await dataSource.createExtraMedication(token: token, data: data);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final createExtraMedicationProvider = AsyncNotifierProvider<CreateExtraMedicationNotifier, Map<String, dynamic>?>(() {
  return CreateExtraMedicationNotifier();
});

// ========== PRESCRIPTION STATUS PROVIDER ==========

class PrescriptionStatusNotifier extends AsyncNotifier<Map<String, dynamic>?> {
  @override
  FutureOr<Map<String, dynamic>?> build() => null;

  Future<void> updateStatus(String token, int prescriptionId, int status, {String? notes}) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(pharmacistRemoteDataSourceProvider);
      final result = await dataSource.updatePrescriptionStatus(
        token: token,
        prescriptionId: prescriptionId,
        status: status,
        notes: notes,
      );
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final prescriptionStatusProvider = AsyncNotifierProvider<PrescriptionStatusNotifier, Map<String, dynamic>?>(() {
  return PrescriptionStatusNotifier();
});
