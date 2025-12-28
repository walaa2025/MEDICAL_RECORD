// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  id: json['id'] as String?,
  name: json['name'] as String,
  nationalId: json['nationalId'] as String,
  password: json['password'] as String,
  specialization: json['specialization'] as String,
  licenseNumber: json['licenseNumber'] as String,
  yearsOfExperience: (json['yearsOfExperience'] as num).toInt(),
  clinicAddress: json['clinicAddress'] as String,
  bio: json['bio'] as String,
);

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nationalId': instance.nationalId,
      'password': instance.password,
      'specialization': instance.specialization,
      'licenseNumber': instance.licenseNumber,
      'yearsOfExperience': instance.yearsOfExperience,
      'clinicAddress': instance.clinicAddress,
      'bio': instance.bio,
    };
