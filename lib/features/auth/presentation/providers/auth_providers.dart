
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midical_record/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:midical_record/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:midical_record/features/auth/domain/repositories/auth_repository.dart';
import 'package:midical_record/features/auth/domain/usecases/login_usecase.dart';
import 'package:midical_record/features/auth/domain/usecases/sign_up_patient_usecase.dart';
import 'package:midical_record/features/auth/domain/usecases/sign_up_doctor_usecase.dart';
import 'package:midical_record/features/auth/domain/entities/auth_entity.dart';
import 'package:midical_record/features/auth/domain/entities/doctor_entity.dart';
import 'package:midical_record/features/auth/data/models/auth_model.dart';
import 'package:midical_record/core/services/token_storage_service.dart';

// ========== REPOSITORY PROVIDERS ==========

/// Provider for the Auth Token
final authTokenProvider = FutureProvider<String?>((ref) async {
  return await TokenStorageService.getToken();
});


/// Provider for the Remote Data Source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

/// Provider for the Repository (legacy - will be refactored)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

// ========== USECASE PROVIDERS (legacy) ==========

/// Provider for LoginUseCase (legacy - will be refactored)
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// Provider for SignUpPatientUseCase (legacy - will be refactored)
final signUpPatientUseCaseProvider = Provider<SignUpPatientUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpPatientUseCase(repository);
});

/// Provider for SignUpDoctorUseCase (legacy - will be refactored)
final signUpDoctorUseCaseProvider = Provider<SignUpDoctorUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpDoctorUseCase(repository);
});

// ========== NEW API CONTROLLERS ==========

/// Login Controller - Updated to use new LoginResponseModel
/// Returns login response with accessToken, role, and userId
class LoginController extends AsyncNotifier<LoginResponseModel?> {
  @override
  FutureOr<LoginResponseModel?> build() {
    return null; // Initial state
  }

  /// Login with identifier (nationalId or patient code) and password
  /// Stores the access token and returns user info (role, userId)
  Future<void> login(String identifier, String password) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(authRemoteDataSourceProvider);
      final response = await dataSource.login(
        identifier: identifier,
        password: password,
      );
      
      // Store the access token and user info
      await TokenStorageService.saveAuthData(
        token: response.accessToken,
        userId: response.userId,
        role: response.role,
      );
      
      // Update state with login response
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final loginControllerProvider = AsyncNotifierProvider<LoginController, LoginResponseModel?>(() {
  return LoginController();
});

/// NEW: Patient Registration Controller
/// Uses new API models and returns PatientRegistrationResponseModel
class SignUpPatientController extends AsyncNotifier<PatientRegistrationResponseModel?> {
  @override
  FutureOr<PatientRegistrationResponseModel?> build() {
    return null; // Initial state
  }

  /// Register a new patient with simplified fields
  Future<void> registerPatient(PatientRegistrationModel patient) async {
    state = const AsyncValue.loading();
    try {
      final dataSource = ref.read(authRemoteDataSourceProvider);
      final response = await dataSource.registerPatient(patient);
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final signUpPatientControllerProvider =
    AsyncNotifierProvider<SignUpPatientController, PatientRegistrationResponseModel?>(() {
  return SignUpPatientController();
});

/// Doctor Registration Controller (legacy - will be refactored)
class SignUpDoctorController extends AsyncNotifier<void> {
  late SignUpDoctorUseCase _signUpDoctorUseCase;

  @override
  FutureOr<void> build() {
    _signUpDoctorUseCase = ref.watch(signUpDoctorUseCaseProvider);
    return null;
  }

  Future<void> register(DoctorEntity doctor) async {
    state = const AsyncValue.loading();
    final result = await _signUpDoctorUseCase(doctor);
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (success) => state = const AsyncValue.data(null),
    );
  }
}

final signUpDoctorControllerProvider = AsyncNotifierProvider<SignUpDoctorController, void>(() {
  return SignUpDoctorController();
});

// ========== AUTH ACTIONS PROVIDER ==========

class AuthNotifier {
  final Ref ref;
  AuthNotifier(this.ref);

  Future<void> logout() async {
    await TokenStorageService.clearAuthData();
    // Additional logout logic (like clearing other providers) can be added here
  }
}

final authProvider = Provider<AuthNotifier>((ref) {
  return AuthNotifier(ref);
});
