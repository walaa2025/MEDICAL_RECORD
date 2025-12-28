
import 'package:flutter_test/flutter_test.dart';
import 'package:midical_record/features/auth/data/models/doctor_model.dart';
import 'package:midical_record/features/auth/domain/entities/doctor_entity.dart';

void main() {
  group('Doctor Auth Data Test', () {
    const tDoctorEntity = DoctorEntity(
      name: 'Dr. Smith',
      nationalId: '1234567890',
      password: 'password123',
      confirmPassword: 'password123',
      specialization: 'Cardiologist',
      licenseNumber: 'DOC-12345',
    );

    test('should convert DoctorEntity to DoctorModel correctly', () {
      final model = DoctorModel.fromEntity(tDoctorEntity);
      expect(model.name, tDoctorEntity.name);
      expect(model.specialization, 'Cardiologist');
    });

    test('should serialize DoctorModel to JSON correctly', () {
      final model = DoctorModel.fromEntity(tDoctorEntity);
      final json = model.toJson();
      
      expect(json['name'], 'Dr. Smith');
      expect(json['specialization'], 'Cardiologist');
      expect(json['licenseNumber'], 'DOC-12345');
    });
  });
}
