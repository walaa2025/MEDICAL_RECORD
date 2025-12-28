
// This file establishes the "Contract" for our data layer.
// The Domain layer (here) tells the Data layer WHAT to do, but not HOW to do it.

import 'package:dartz/dartz.dart'; // We use dartz for Either<Failure, Success>
import 'package:midical_record/features/auth/domain/entities/auth_entity.dart';
import 'package:midical_record/features/auth/domain/entities/doctor_entity.dart';

// A simple class to represent an error/failure.
class Failure {
  final String message;
  Failure(this.message);
}

// The abstract class (Interface) for Authentication Repositories.
abstract class AuthRepository {
  
  // Login with National ID and Password.
  // Returns Either a Failure (error) or an AuthEntity (success).
  Future<Either<Failure, AuthEntity>> login(String nationalId, String password);

  // Sign up a new Patient.
  // Takes the PatientEntity (without ID potentially, but for now we pass the object).
  // Returns success or failure.
  Future<Either<Failure, Unit>> signUpPatient(PatientEntity patient);

  // Sign up a new Doctor.
  Future<Either<Failure, Unit>> signUpDoctor(DoctorEntity doctor);
}
