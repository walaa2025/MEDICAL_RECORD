import 'package:midical_record/core/constants/app_enums.dart';

// ========== CHILD MODELS (Detailed) ==========

class AllergyModel {
  final String allergenName;
  final String? reaction;
  final String? severity;

  AllergyModel({required this.allergenName, this.reaction, this.severity});

  factory AllergyModel.fromJson(Map<String, dynamic> json) {
    return AllergyModel(
      allergenName: json['allergenName'] ?? '',
      reaction: json['reaction'],
      severity: json['severity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'allergenName': allergenName,
        'reaction': reaction,
        'severity': severity,
      };
}

class ChronicDiseaseModel {
  final String diseaseName;
  final String? description;
  final DateTime? diagnosisDate;

  ChronicDiseaseModel({required this.diseaseName, this.description, this.diagnosisDate});

  factory ChronicDiseaseModel.fromJson(Map<String, dynamic> json) {
    return ChronicDiseaseModel(
      diseaseName: json['diseaseName'] ?? '',
      description: json['description'],
      diagnosisDate: json['diagnosisDate'] != null ? DateTime.parse(json['diagnosisDate']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'diseaseName': diseaseName,
        'description': description,
        'diagnosisDate': diagnosisDate?.toIso8601String(),
      };
}

class SurgeryModel {
  final String surgeryName;
  final String? description;
  final DateTime? surgeryDate;
  final String? hospital;
  final String? surgeon;

  SurgeryModel({
    required this.surgeryName,
    this.description,
    this.surgeryDate,
    this.hospital,
    this.surgeon,
  });

  factory SurgeryModel.fromJson(Map<String, dynamic> json) {
    return SurgeryModel(
      surgeryName: json['surgeryName'] ?? '',
      description: json['description'],
      surgeryDate: json['surgeryDate'] != null ? DateTime.parse(json['surgeryDate']) : null,
      hospital: json['hospital'],
      surgeon: json['surgeon'],
    );
  }

  Map<String, dynamic> toJson() => {
        'surgeryName': surgeryName,
        'description': description,
        'surgeryDate': surgeryDate?.toIso8601String(),
        'hospital': hospital,
        'surgeon': surgeon,
      };
}

class CurrentMedicationModel {
  final String medicationName;
  final String? dosage;
  final String? frequency;
  final String? duration;
  final String? instructions;

  CurrentMedicationModel({
    required this.medicationName,
    this.dosage,
    this.frequency,
    this.duration,
    this.instructions,
  });

  factory CurrentMedicationModel.fromJson(Map<String, dynamic> json) {
    return CurrentMedicationModel(
      medicationName: json['medicationName'] ?? '',
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'], // API uses string duration here
      instructions: json['instructions'],
    );
  }

  Map<String, dynamic> toJson() => {
        'medicationName': medicationName,
        'dosage': dosage,
        'frequency': frequency,
        'duration': duration,
        'instructions': instructions,
      };
}

// ========== PROFILE MODELS ==========

/// Patient Profile (GET Response)
/// Matches "https://localhost:7164/api/Patient/profile(GET)"
class PatientProfileModel {
  final int? id;
  final int? userId;
  final String fullName;
  final DateTime? dateOfBirth;
  final Gender gender;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final BloodType? bloodType;
  final double? weight;
  final double? height;
  final String? emergencyContact;
  final String? emergencyPhone;

  PatientProfileModel({
    this.id,
    this.userId,
    required this.fullName,
    this.dateOfBirth,
    required this.gender,
    this.phoneNumber,
    this.email,
    this.address,
    this.bloodType,
    this.weight,
    this.height,
    this.emergencyContact,
    this.emergencyPhone,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      id: json['id'],
      userId: json['userId'],
      fullName: json['fullName'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      gender: Gender.fromValue(json['gender'] ?? 1),
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
      bloodType: json['bloodType'] != null ? BloodType.fromValue(json['bloodType']) : null,
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      emergencyContact: json['emergencyContact'],
      emergencyPhone: json['emergencyPhone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'fullName': fullName,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'gender': gender.value,
        'phoneNumber': phoneNumber,
        'email': email,
        'address': address,
        'bloodType': bloodType?.value,
        'weight': weight,
        'height': height,
        'emergencyContact': emergencyContact,
        'emergencyPhone': emergencyPhone,
      };
}

/// Patient Initialization Request (POST)
/// Matches "https://localhost:7164/api/Patient/initialize-profile"
class PatientInitializationModel {
  final String fullName;
  final DateTime dateOfBirth;
  final int gender; // 1 or 2
  final String? phoneNumber;
  final String? email;
  final String? address;
  final int? bloodType;
  final double? weight;
  final double? height;
  final String? emergencyContact;
  final String? emergencyPhone;
  final List<AllergyModel> allergies;
  final List<ChronicDiseaseModel> chronicDiseases;
  final List<SurgeryModel> surgeries;
  final List<CurrentMedicationModel> currentMedications;
  final String? notes;

  PatientInitializationModel({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    this.phoneNumber,
    this.email,
    this.address,
    this.bloodType,
    this.weight,
    this.height,
    this.emergencyContact,
    this.emergencyPhone,
    this.allergies = const [],
    this.chronicDiseases = const [],
    this.surgeries = const [],
    this.currentMedications = const [],
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'gender': gender,
        'phoneNumber': phoneNumber,
        'email': email,
        'address': address,
        'bloodType': bloodType,
        'weight': weight,
        'height': height,
        'emergencyContact': emergencyContact,
        'emergencyPhone': emergencyPhone,
        'allergies': allergies.map((e) => e.toJson()).toList(),
        'chronicDiseases': chronicDiseases.map((e) => e.toJson()).toList(),
        'surgeries': surgeries.map((e) => e.toJson()).toList(),
        'currentMedications': currentMedications.map((e) => e.toJson()).toList(),
        'notes': notes,
      };
}

// ========== EMERGENCY MODEL ==========

/// Emergency Screen Data (GET)
/// Matches "https://localhost:7164/api/Patient/emergency-screen"
class EmergencyDataModel {
  final String fullName;
  final BloodType? bloodType;
  final List<String> allergies; // List of strings in this endpoint
  final List<String> chronicDiseases; // List of strings in this endpoint
  final List<String> currentMedications; // List of strings in this endpoint
  final String? emergencyContact;
  final String? emergencyPhone;
  final String? qrCodeUrl;

  EmergencyDataModel({
    required this.fullName,
    this.bloodType,
    required this.allergies,
    required this.chronicDiseases,
    required this.currentMedications,
    this.emergencyContact,
    this.emergencyPhone,
    this.qrCodeUrl,
  });

  factory EmergencyDataModel.fromJson(Map<String, dynamic> json) {
    return EmergencyDataModel(
      fullName: json['fullName'] ?? '',
      bloodType: json['bloodType'] != null ? BloodType.fromValue(json['bloodType']) : null,
      allergies: json['allergies'] != null ? List<String>.from(json['allergies']) : [],
      chronicDiseases: json['chronicDiseases'] != null ? List<String>.from(json['chronicDiseases']) : [],
      currentMedications: json['currentMedications'] != null ? List<String>.from(json['currentMedications']) : [],
      emergencyContact: json['emergencyContact'],
      emergencyPhone: json['emergencyPhone'],
      qrCodeUrl: json['qrCodeUrl'],
    );
  }
}

// ========== RECORDS & PRESCRIPTIONS ==========

class MedicalRecordModel {
  final int? id;
  final int? patientId;
  final int? doctorId;
  final String diagnosis;
  final String? notes;
  final String? symptoms;
  final String? treatment;
  final DateTime recordDate;
  final String doctorName;
  final String patientName;

  MedicalRecordModel({
    this.id,
    this.patientId,
    this.doctorId,
    required this.diagnosis,
    this.notes,
    this.symptoms,
    this.treatment,
    required this.recordDate,
    required this.doctorName,
    required this.patientName,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      diagnosis: json['diagnosis'] ?? '',
      notes: json['notes'],
      symptoms: json['symptoms'],
      treatment: json['treatment'],
      recordDate: DateTime.parse(json['recordDate']),
      doctorName: json['doctorName'] ?? '',
      patientName: json['patientName'] ?? '',
    );
  }
}

class PrescriptionItemModel {
  final int? id;
  final int? prescriptionId;
  final String medicationName;
  final String? dosage;
  final String? frequency;
  final String? duration;
  final String? instructions;
  final int quantity;
  final bool isDispensed;

  PrescriptionItemModel({
    this.id,
    this.prescriptionId,
    required this.medicationName,
    this.dosage,
    this.frequency,
    this.duration,
    this.instructions,
    this.quantity = 0,
    this.isDispensed = false,
  });

  factory PrescriptionItemModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemModel(
      id: json['id'],
      prescriptionId: json['prescriptionId'],
      medicationName: json['medicationName'] ?? '',
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'],
      instructions: json['instructions'],
      quantity: json['quantity'] ?? 0,
      isDispensed: json['isDispensed'] ?? false,
    );
  }
}

class PrescriptionModel {
  final int id;
  final int? patientId;
  final int? doctorId;
  final String? diagnosis;
  final String? notes;
  final PrescriptionStatus status;
  final DateTime prescriptionDate;
  final String doctorName;
  final String patientName;
  final List<PrescriptionItemModel> items;

  PrescriptionModel({
    required this.id,
    this.patientId,
    this.doctorId,
    this.diagnosis,
    this.notes,
    required this.status,
    required this.prescriptionDate,
    required this.doctorName,
    required this.patientName,
    required this.items,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] ?? 0,
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      diagnosis: json['diagnosis'],
      notes: json['notes'],
      status: PrescriptionStatus.fromValue(json['status'] ?? 1),
      prescriptionDate: DateTime.parse(json['prescriptionDate']),
      doctorName: json['doctorName'] ?? '',
      patientName: json['patientName'] ?? '',
      items: json['items'] != null
          ? (json['items'] as List).map((i) => PrescriptionItemModel.fromJson(i)).toList()
          : [],
    );
  }
}
