import 'package:flutter_test/flutter_test.dart';
import 'package:midical_record/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:midical_record/features/auth/data/models/auth_model.dart';
import 'package:midical_record/features/auth/domain/entities/auth_entity.dart';
import 'package:midical_record/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  test('PatientEntity to PatientModel conversion and JSON serialization', () {
    final entity = PatientEntity(
      id: '123',
      name: 'John Doe',
      age: 30,
      dateOfBirth: DateTime(1990, 1, 1),
      gender: 'Male',
      bloodType: 'O+',
      height: 180.0,
      weight: 75.0,
      chronicDiseases: 'None',
      currentMedications: 'None',
      allergies: 'Peanuts',
      surgicalOperations: 'None',
      attendingDoctor: 'Dr. Smith',
      emergencyNumber: '911',
    );

    final model = PatientModel.fromEntity(entity);

    expect(model.name, 'John Doe');
    expect(model.allergies, 'Peanuts');

    final json = model.toJson();
    expect(json['name'], 'John Doe');
    expect(json['age'], 30);
    expect(json['allergies'], 'Peanuts');
    expect(json['dateOfBirth'], isA<String>());
  });

  test('AuthRepositoryImpl converts Entity to Model before calling DataSource', () async {
    // This is a partial integration test to ensure types match and no runtime errors occur during the call structure.
    final datasource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(datasource);

    final entity = PatientEntity(
      id: '123',
      name: 'Jane Doe',
      age: 25,
      dateOfBirth: DateTime(1995, 5, 5),
      gender: 'Female',
      bloodType: 'A+',
      height: 165.0,
      weight: 60.0,
      chronicDiseases: 'Asthma',
      currentMedications: 'Inhaler',
      allergies: 'None',
      surgicalOperations: 'Appendectomy',
      attendingDoctor: 'Dr. House',
      emergencyNumber: '112',
    );

    // We expect this to print the JSON to console (mock behavior) and complete successfully.
    final result = await repository.signUpPatient(entity);

    expect(result.isRight(), true);
  });
}
