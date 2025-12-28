
import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String? id;
  final String nationalId;
  final String password;
  final String confirmPassword;
  final String name; // maps to fullName
  final String? email;
  final String? phoneNumber;
  final String licenseNumber;
  final String? licenseDocumentUrl;
  final String? specialization;
  final String? hospital;

  const DoctorEntity({
    this.id,
    required this.nationalId,
    required this.password,
    required this.confirmPassword,
    required this.name,
    this.email,
    this.phoneNumber,
    required this.licenseNumber,
    this.licenseDocumentUrl,
    this.specialization,
    this.hospital,
  });

  @override
  List<Object?> get props => [
        id,
        nationalId,
        password,
        confirmPassword,
        name,
        email,
        phoneNumber,
        licenseNumber,
        licenseDocumentUrl,
        specialization,
        hospital,
      ];
}
