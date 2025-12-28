import 'package:midical_record/core/constants/app_enums.dart';
import 'package:midical_record/features/patient/data/models/patient_models.dart';

/// Doctor Profile Model
class DoctorProfileModel {
  final int? id;
  final int? userId;
  final String fullName;
  final String? specialization;
  final String? licenseNumber;
  final String? hospital;
  final String? phoneNumber;
  final String? email;

  DoctorProfileModel({
    this.id,
    this.userId,
    required this.fullName,
    this.specialization,
    this.licenseNumber,
    this.hospital,
    this.phoneNumber,
    this.email,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileModel(
      id: json['id'],
      userId: json['userId'],
      fullName: json['fullName'] ?? '',
      specialization: json['specialization'],
      licenseNumber: json['licenseNumber'],
      hospital: json['hospital'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'hospital': hospital,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }
}

/// Patient Search Result Model (Complex)
/// Matches "https://localhost:7164/api/Doctor/search-patient"
class PatientSearchResultModel {
  final int id;
  final String fullName;
  final DateTime? dateOfBirth;
  final Gender gender;
  final BloodType? bloodType;
  final double? weight;
  final double? height;
  final String? emergencyContact;
  final String? emergencyPhone;
  final String? patientCode;
  final List<AllergyModel> allergies;
  final List<ChronicDiseaseModel> chronicDiseases;
  final List<SurgeryModel> surgeries;
  final List<MedicalRecordModel> medicalRecords;
  final List<PrescriptionModel> prescriptions;

  PatientSearchResultModel({
    required this.id,
    required this.fullName,
    this.dateOfBirth,
    required this.gender,
    this.bloodType,
    this.weight,
    this.height,
    this.emergencyContact,
    this.emergencyPhone,
    this.patientCode,
    required this.allergies,
    required this.chronicDiseases,
    required this.surgeries,
    required this.medicalRecords,
    required this.prescriptions,
  });

  factory PatientSearchResultModel.fromJson(Map<String, dynamic> json) {
    return PatientSearchResultModel(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      gender: Gender.fromValue(json['gender'] ?? 1),
      bloodType: json['bloodType'] != null ? BloodType.fromValue(json['bloodType']) : null,
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      emergencyContact: json['emergencyContact'],
      emergencyPhone: json['emergencyPhone'],
      patientCode: json['patientCode'],
      allergies: json['allergies'] != null
          ? (json['allergies'] as List).map((e) => AllergyModel.fromJson(e)).toList()
          : [],
      chronicDiseases: json['chronicDiseases'] != null
          ? (json['chronicDiseases'] as List).map((e) => ChronicDiseaseModel.fromJson(e)).toList()
          : [],
      surgeries: json['surgeries'] != null
          ? (json['surgeries'] as List).map((e) => SurgeryModel.fromJson(e)).toList()
          : [],
      medicalRecords: json['medicalRecords'] != null
          ? (json['medicalRecords'] as List).map((e) => MedicalRecordModel.fromJson(e)).toList()
          : [],
      prescriptions: json['prescriptions'] != null
          ? (json['prescriptions'] as List).map((e) => PrescriptionModel.fromJson(e)).toList()
          : [],
    );
  }
}

/// Add Medical Record Request Model
class AddMedicalRecordModel {
  final int patientId;
  final String diagnosis;
  final String? notes;
  final String? symptoms;
  final String? treatment;
  final String? recordDate; // API expects ISO string

  AddMedicalRecordModel({
    required this.patientId,
    required this.diagnosis,
    this.notes,
    this.symptoms,
    this.treatment,
    this.recordDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'diagnosis': diagnosis,
      'notes': notes,
      'symptoms': symptoms,
      'treatment': treatment,
      'recordDate': recordDate ?? DateTime.now().toIso8601String(),
    };
  }
}

/// Add Prescription Request Model
class AddPrescriptionModel {
  final int patientId;
  final String diagnosis;
  final String? notes;
  final List<AddPrescriptionItemModel> items;

  AddPrescriptionModel({
    required this.patientId,
    required this.diagnosis,
    this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'diagnosis': diagnosis,
      'notes': notes,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

class AddPrescriptionItemModel {
  final String medicationName;
  final String? dosage;
  final String? frequency;
  final String? duration;
  final String? instructions;
  final int quantity;
  final String? unit;

  AddPrescriptionItemModel({
    required this.medicationName,
    this.dosage,
    this.frequency,
    this.duration,
    this.instructions,
    this.quantity = 0,
    this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicationName': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
      'quantity': quantity,
      'unit': unit,
    };
  }
}
