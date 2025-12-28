
import 'package:flutter/material.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/auth/presentation/screens/login_screen.dart';
import 'package:midical_record/features/auth/presentation/screens/splash_screen.dart';
import 'package:midical_record/features/auth/presentation/screens/sign_up_selection_screen.dart';
import 'package:midical_record/features/auth/presentation/screens/patient_sign_up_screen.dart';
import 'package:midical_record/features/auth/presentation/screens/doctor_sign_up_screen.dart';
import 'package:midical_record/features/auth/presentation/screens/pharmacist_sign_up_screen.dart';
import 'package:midical_record/features/patient/presentation/screens/patient_dashboard_screen.dart';
import 'package:midical_record/features/patient/presentation/screens/emergency_screen.dart';
import 'package:midical_record/features/patient/presentation/screens/medical_records_screen.dart';
import 'package:midical_record/features/patient/presentation/screens/prescriptions_screen.dart';
import 'package:midical_record/features/patient/presentation/screens/medical_record_details_screen.dart';
import 'package:midical_record/features/patient/presentation/screens/prescription_details_screen.dart';
import 'package:midical_record/features/patient/presentation/screens/patient_profile_screen.dart';
import 'package:midical_record/features/patient/presentation/screens/patient_edit_profile_screen.dart';
import 'package:midical_record/features/patient/data/models/patient_models.dart';
import 'package:midical_record/features/doctor/presentation/screens/doctor_patient_details_screen.dart';
import 'package:midical_record/features/doctor/presentation/screens/add_medical_record_screen.dart';
import 'package:midical_record/features/doctor/presentation/screens/add_prescription_screen.dart';
import 'package:midical_record/features/doctor/presentation/screens/doctor_profile_screen.dart';
import 'package:midical_record/features/doctor/data/models/doctor_models.dart';
import 'package:midical_record/features/pharmacist/presentation/screens/pharmacist_dispense_screen.dart';
import 'package:midical_record/features/pharmacist/presentation/screens/pharmacist_profile_screen.dart';
import 'package:midical_record/features/pharmacist/data/models/pharmacist_models.dart';
import 'package:midical_record/features/patient/presentation/screens/notifications_screen.dart';
import 'package:midical_record/features/patient/presentation/screens/patient_initialize_profile_screen.dart';

/// App navigation router configuration
/// Uses GoRouter for declarative routing
final goRouterProvider = GoRouter(
  // The initial route when the app starts
  initialLocation: '/login',
  
  routes: [
    // ========== AUTH ROUTES ==========
    
    // Route for the Login Screen
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    
    // Route for the Sign Up Selection Screen
    GoRoute(
      path: '/signup_selection',
      builder: (context, state) => const SignUpSelectionScreen(),
    ),
    
    // Route for the Patient Sign Up Screen
    GoRoute(
      path: '/signup_patient',
      builder: (context, state) => const PatientSignUpScreen(),
    ),

    // Route for the Doctor Sign Up Screen
    GoRoute(
      path: '/signup_doctor',
      builder: (context, state) => const DoctorSignUpScreen(),
    ),
    
    // Route for the Pharmacist Sign Up Screen
    GoRoute(
      path: '/signup_pharmacist',
      builder: (context, state) => const PharmacistSignUpScreen(),
    ),
    
    // ========== PATIENT ROUTES ==========
    
    // Patient Dashboard (Home)
    GoRoute(
      path: '/patient/dashboard',
      builder: (context, state) => const PatientDashboardScreen(),
    ),

    // Patient Initialize Profile
    GoRoute(
      path: '/patient/initialize-profile',
      builder: (context, state) => const PatientInitializeProfileScreen(),
    ),
    
    // Emergency Screen with QR Code
    GoRoute(
      path: '/patient/emergency',
      builder: (context, state) => const EmergencyScreen(),
    ),
    
    // QR Code Screen (alias for emergency)
    GoRoute(
      path: '/patient/qr',
      builder: (context, state) => const EmergencyScreen(),
    ),
    
    // Medical Records List
    GoRoute(
      path: '/patient/medical-records',
      builder: (context, state) => const MedicalRecordsScreen(),
    ),
    
    // Medical Record Details
    GoRoute(
      path: '/patient/medical-record/:id',
      builder: (context, state) {
        final record = state.extra as MedicalRecordModel?;
        if (record == null) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(appBar: AppBar(title: Text(l10n.errorTitle)), body: Center(child: Text(l10n.recordNotFound)));
        }
        return MedicalRecordDetailsScreen(record: record);
      },
    ),
    
    // Prescriptions List
    GoRoute(
      path: '/patient/prescriptions',
      builder: (context, state) => const PrescriptionsScreen(),
    ),
    
    // Prescription Details
    GoRoute(
      path: '/patient/prescription/:id',
      builder: (context, state) {
        final prescription = state.extra as PrescriptionModel?;
        if (prescription == null) {
           final l10n = AppLocalizations.of(context)!;
           return Scaffold(appBar: AppBar(title: Text(l10n.errorTitle)), body: Center(child: Text(l10n.prescriptionNotFound)));
        }
        return PrescriptionDetailsScreen(prescription: prescription);
      },
    ),
    
    // Profile Screen
    GoRoute(
      path: '/patient/profile',
      builder: (context, state) => const PatientProfileScreen(),
    ),
    
    // Edit Profile Screen
    GoRoute(
      path: '/patient/profile/edit',
      builder: (context, state) {
        final profile = state.extra as PatientProfileModel?;
        if (profile == null) {
           final l10n = AppLocalizations.of(context)!;
           return Scaffold(appBar: AppBar(title: Text(l10n.errorTitle)), body: Center(child: Text(l10n.profileNotFound)));
        }
        return PatientEditProfileScreen(profile: profile);
      },
    ),
    
    // ========== DOCTOR ROUTES ==========
    
    // Doctor Details Screen
    GoRoute(
      path: '/doctor/patient-record/:id',
      builder: (context, state) {
        // We expect the PatientSearchResultModel to be passed in extra
        // If not (e.g. deep link), we might need to fetch it again using the ID (patientCode).
        // For now, assume it's passed or show error.
        final patient = state.extra as PatientSearchResultModel?;
        if (patient == null) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(appBar: AppBar(title: Text(l10n.errorTitle)), body: Center(child: Text(l10n.patientNotFound)));
        }
        return DoctorPatientDetailsScreen(patient: patient);
      },
    ),

    // Add Medical Record
    GoRoute(
      path: '/doctor/add-record',
      builder: (context, state) {
        final patient = state.extra as PatientSearchResultModel?;
        if (patient == null) return const SizedBox.shrink(); 
        return AddMedicalRecordScreen(patientId: patient.id, patientName: patient.fullName);
      },
    ),

    // Add Prescription
    GoRoute(
      path: '/doctor/add-prescription',
      builder: (context, state) {
        final patient = state.extra as PatientSearchResultModel?;
        if (patient == null) return const SizedBox.shrink();
        return AddPrescriptionScreen(patientId: patient.id, patientName: patient.fullName);
      },
    ),

    // Placeholders for doctor profile
    GoRoute(
      path: '/doctor/profile',
      builder: (context, state) => const DoctorProfileScreen(),
    ),
    
    // ========== PHARMACIST ROUTES ==========
    
    // Dispense Screen
    GoRoute(
      path: '/pharmacist/dispense/:id',
      builder: (context, state) {
        final prescription = state.extra as PrescriptionSearchResultModel?;
        if (prescription == null) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(appBar: AppBar(title: Text(l10n.errorTitle)), body: Center(child: Text(l10n.prescriptionNotFound)));
        }
        return PharmacistDispenseScreen(prescription: prescription);
      },
    ),
    
    // Pharmacist Profile
    GoRoute(
      path: '/pharmacist/profile',
      builder: (context, state) => const PharmacistProfileScreen(),
    ),

    // Notifications Screen
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ],
);
