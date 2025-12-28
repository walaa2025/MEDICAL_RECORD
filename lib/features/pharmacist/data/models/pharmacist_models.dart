import 'package:midical_record/core/constants/app_enums.dart';

/// Pharmacist Profile Model
class PharmacistProfileModel {
  final int? userId;
  final String nationalId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String licenseNumber;
  final String pharmacyName;
  final String? profileImageUrl;
  final UserStatus status;

  PharmacistProfileModel({
    this.userId,
    required this.nationalId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.licenseNumber,
    required this.pharmacyName,
    this.profileImageUrl,
    this.status = UserStatus.pending,
  });

  factory PharmacistProfileModel.fromJson(Map<String, dynamic> json) {
    return PharmacistProfileModel(
      userId: json['userId'],
      nationalId: json['nationalId'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      licenseNumber: json['licenseNumber'] ?? '',
      pharmacyName: json['pharmacyName'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      status: json['status'] != null ? UserStatus.fromValue(json['status']) : UserStatus.pending,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nationalId': nationalId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'licenseNumber': licenseNumber,
      'pharmacyName': pharmacyName,
      'profileImageUrl': profileImageUrl,
      'status': status.value,
    };
  }
}

/// Prescription Search Result Model
class PrescriptionSearchResultModel {
  final int prescriptionId;
  final String patientName;
  final String doctorName;
  final DateTime prescriptionDate;
  final PrescriptionStatus status;
  final List<MedicationItemForDispense> medications;
  final String? notes;

  PrescriptionSearchResultModel({
    required this.prescriptionId,
    required this.patientName,
    required this.doctorName,
    required this.prescriptionDate,
    required this.status,
    required this.medications,
    this.notes,
  });

  factory PrescriptionSearchResultModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionSearchResultModel(
      prescriptionId: json['id'] ?? 0, // Mapped from 'id'
      patientName: json['patientName'] ?? '',
      doctorName: json['doctorName'] ?? '',
      prescriptionDate: DateTime.parse(json['prescriptionDate']),
      status: PrescriptionStatus.fromValue(json['status'] ?? 1),
      medications: json['items'] != null // Mapped from 'items'
          ? (json['items'] as List).map((m) => MedicationItemForDispense.fromJson(m)).toList()
          : [],
      notes: json['notes'],
    );
  }
}

/// Medication Item for Dispensing
class MedicationItemForDispense {
  final int? id; // added id
  final int? prescriptionId; // added
  final String medicationName;
  final String? dosage;
  final String? frequency;
  final String? duration;
  final String? instructions;
  final int quantity; // added
  final bool isDispensed;

  MedicationItemForDispense({
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

  factory MedicationItemForDispense.fromJson(Map<String, dynamic> json) {
    return MedicationItemForDispense(
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

/// Drug Interaction Model
class DrugInteractionModel {
  final String medication1;
  final String medication2;
  final String severity; 
  final String? description;
  final String? recommendation;

  DrugInteractionModel({
    required this.medication1,
    required this.medication2,
    required this.severity,
    this.description,
    this.recommendation,
  });

  factory DrugInteractionModel.fromJson(Map<String, dynamic> json) {
    return DrugInteractionModel(
      medication1: json['medication1'] ?? '',
      medication2: json['medication2'] ?? '',
      severity: json['severity'] ?? 'Low',
      description: json['description'],
      recommendation: json['recommendation'],
    );
  }
}

/// Dispense Item Model
class DispenseItemModel {
  final int prescriptionItemId;
  final bool dispensed;
  final String? notes;

  DispenseItemModel({
    required this.prescriptionItemId,
    required this.dispensed,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'prescriptionItemId': prescriptionItemId,
      'dispensed': dispensed,
      'notes': notes,
    };
  }
}

/// Dispense Prescription Request Model
class DispensePrescriptionModel {
  final int prescriptionId;
  final String? notes;
  final List<DispenseItemModel> items;

  DispensePrescriptionModel({
    required this.prescriptionId,
    this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'prescriptionId': prescriptionId,
      'notes': notes,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}
