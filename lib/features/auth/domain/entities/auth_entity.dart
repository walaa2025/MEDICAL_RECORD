
// This file contains the "Entities" for the Authentication feature.
// Entities are just simple classes that hold data. They don't do any logic.

// This class represents a logged-in user (generic).
class AuthEntity {
  final String userId;
  final String nationalId; // The ID used for login.
  final String token; // The security token from the API.

  AuthEntity({
    required this.userId,
    required this.nationalId,
    required this.token,
  });
}

// This class represents a Patient profile.
// It holds all the medical details the user asked for.
class PatientEntity {
  final String id;
  final String name;
  final int age;
  final DateTime dateOfBirth;
  final String gender; // 'Male' or 'Female'
  final String bloodType;
  final double height; // in cm
  final double weight; // in kg
  final String chronicDiseases; // Comma separated or description
  final String currentMedications;
  final String allergies;
  final String surgicalOperations;
  final String attendingDoctor;
  final String emergencyNumber;

  PatientEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodType,
    required this.height,
    required this.weight,
    required this.chronicDiseases,
    required this.currentMedications,
    required this.allergies,
    required this.surgicalOperations,
    required this.attendingDoctor,
    required this.emergencyNumber,
  });
}
