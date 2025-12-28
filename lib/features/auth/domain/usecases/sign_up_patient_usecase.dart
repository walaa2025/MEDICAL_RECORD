
import 'package:dartz/dartz.dart';
import 'package:midical_record/features/auth/domain/entities/auth_entity.dart';
import 'package:midical_record/features/auth/domain/repositories/auth_repository.dart';

// Use Case for signing up a patient.
class SignUpPatientUseCase {
  final AuthRepository _repository;

  SignUpPatientUseCase(this._repository);

  // Takes a PatientEntity and calls the repository to save it.
  Future<Either<Failure, Unit>> call(PatientEntity patient) async {
    return await _repository.signUpPatient(patient);
  }
}
