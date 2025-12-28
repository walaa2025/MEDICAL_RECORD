
import 'package:dartz/dartz.dart';
import 'package:midical_record/features/auth/domain/entities/doctor_entity.dart';
import 'package:midical_record/features/auth/domain/repositories/auth_repository.dart';

class SignUpDoctorUseCase {
  final AuthRepository _repository;

  SignUpDoctorUseCase(this._repository);

  Future<Either<Failure, Unit>> call(DoctorEntity doctor) async {
    return await _repository.signUpDoctor(doctor);
  }
}
