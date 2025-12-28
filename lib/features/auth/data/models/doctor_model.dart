
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/doctor_entity.dart';


class DoctorModel extends DoctorEntity {
  const DoctorModel({
    super.id,
    required super.nationalId,
    required super.password,
    required super.confirmPassword,
    required super.name,
    super.email,
    super.phoneNumber,
    required super.licenseNumber,
    super.licenseDocumentUrl,
    super.specialization,
    super.hospital,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      nationalId: json['nationalId'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
      name: json['fullName'] ?? '',
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      licenseNumber: json['licenseNumber'] ?? '',
      licenseDocumentUrl: json['licenseDocumentUrl'],
      specialization: json['specialization'],
      hospital: json['hospital'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nationalId': nationalId,
      'password': password,
      'confirmPassword': confirmPassword,
      'fullName': name,
      'email': email ?? '',
      'phoneNumber': phoneNumber ?? '',
      'licenseNumber': licenseNumber,
      'licenseDocumentUrl': licenseDocumentUrl ?? '',
      'specialization': specialization ?? '',
      'hospital': hospital ?? '',
    };
  }

  factory DoctorModel.fromEntity(DoctorEntity entity) {
    return DoctorModel(
      id: entity.id,
      nationalId: entity.nationalId,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      licenseNumber: entity.licenseNumber,
      licenseDocumentUrl: entity.licenseDocumentUrl,
      specialization: entity.specialization,
      hospital: entity.hospital,
    );
  }
}
