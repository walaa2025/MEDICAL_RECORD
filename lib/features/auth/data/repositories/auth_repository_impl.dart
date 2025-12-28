
import 'package:dartz/dartz.dart';
import 'package:midical_record/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:midical_record/features/auth/data/models/auth_model.dart';
import 'package:midical_record/features/auth/data/models/doctor_model.dart';
import 'package:midical_record/features/auth/domain/entities/auth_entity.dart';
import 'package:midical_record/features/auth/domain/entities/doctor_entity.dart';
import 'package:midical_record/features/auth/domain/repositories/auth_repository.dart';
import 'package:midical_record/core/services/token_storage_service.dart';

/// Legacy implementation of auth repository
/// This is kept for backward compatibility with existing use cases
/// New code should use data source directly with new models
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AuthEntity>> login(String nationalId, String password) async {
    try {
      // Call new API with identifier
      final result = await _remoteDataSource.login(
        identifier: nationalId,
        password: password,
      );
      
      // Store authentication data in shared preferences
      await TokenStorageService.saveAuthData(
        token: result.accessToken,
        userId: result.userId,
        role: result.role,
      );
      
      // Convert LoginResponseModel to legacy AuthEntity
      final authEntity = AuthEntity(
        userId: result.userId.toString(),
        nationalId: nationalId,
        token: result.accessToken,
      );
      
      return Right(authEntity);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signUpPatient(PatientEntity patient) async {
    try {
      // This method is deprecated - use new PatientRegistrationModel instead
      // For now, create a basic registration request
      final registrationModel = PatientRegistrationModel(
        nationalId: patient.id, // Using ID as nationalId temporarily
        password: 'temp123', // This needs to come from somewhere else
        confirmPassword: 'temp123',
        fullName: patient.name,
        dateOfBirth: patient.dateOfBirth,
        phoneNumber: patient.emergencyNumber,
        email: 'temp@example.com', // This needs to come from somewhere else
      );
      
      await _remoteDataSource.registerPatient(registrationModel);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signUpDoctor(DoctorEntity doctor) async {
    try {
      final doctorModel = DoctorModel.fromEntity(doctor);
      await _remoteDataSource.registerDoctor(doctorModel);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
