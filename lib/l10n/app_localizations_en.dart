// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Medical Record';

  @override
  String welcomeMessage(String name) {
    return 'Welcome, $name';
  }

  @override
  String get dashboard => 'Dashboard';

  @override
  String get profile => 'Profile';

  @override
  String get medicalRecords => 'Medical Records';

  @override
  String get prescriptions => 'Prescriptions';

  @override
  String get emergency => 'Emergency';

  @override
  String get notifications => 'Notifications';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get emergencyAlert => 'Emergency Alert';

  @override
  String get latestPrescriptions => 'Latest Prescriptions';

  @override
  String get viewAll => 'View All';

  @override
  String get initialize => 'Initialize';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get gender => 'Gender';

  @override
  String get bloodType => 'Blood Type';

  @override
  String get height => 'Height (cm)';

  @override
  String get weight => 'Weight (kg)';

  @override
  String get address => 'Address';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get emergencyPhone => 'Emergency Phone';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get completeProfileNote =>
      'Note: You can see full medical details in the Emergency page.';

  @override
  String get noRecords => 'No medical records found';

  @override
  String get recordNotFound => 'Medical record not found';

  @override
  String get noPrescriptions => 'No prescriptions found';

  @override
  String get retry => 'Retry';

  @override
  String error(Object message) {
    return 'Error: $message';
  }

  @override
  String get home => 'Home';

  @override
  String get records => 'Records';

  @override
  String get meds => 'Meds';

  @override
  String get profileShort => 'Profile';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get loadingError => 'Loading error';

  @override
  String get profileNotFound => 'Profile not found';

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get biometrics => 'Biometrics';

  @override
  String get contactInfo => 'Contact Information';

  @override
  String doctorPrefix(Object name) {
    return 'Dr. $name';
  }

  @override
  String get notesAvailable => 'Notes Available';

  @override
  String get medicationsLabel => 'Medications:';

  @override
  String get required => 'Required';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String get saveImageSuccess => 'Image saved to gallery successfully';

  @override
  String saveImageError(Object error) {
    return 'Error saving image: $error';
  }

  @override
  String get saveAsImage => 'Save as Image';

  @override
  String get emergencyCriticalNote =>
      'Critical medical information - For emergency use only';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get noEmergencyInfo => 'No emergency information found';

  @override
  String get allergies => 'Allergies';

  @override
  String get chronicDiseases => 'Chronic Diseases';

  @override
  String get currentMedications => 'Current Medications';

  @override
  String get surgeries => 'Surgeries';

  @override
  String get selectBirthDateError => 'Please select your date of birth';

  @override
  String get medicalHistory => 'Medical History';

  @override
  String get medsAndAllergies => 'Medications & Allergies';

  @override
  String stepCounter(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get selectDate => 'Select Date';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get noDataAdded => 'No data added';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get submit => 'Submit';

  @override
  String get add => 'Add';

  @override
  String get addChronicDisease => 'Add Chronic Disease';

  @override
  String get diseaseName => 'Disease Name';

  @override
  String get description => 'Description';

  @override
  String get addSurgery => 'Add Surgery';

  @override
  String get surgeryName => 'Surgery Name';

  @override
  String get hospital => 'Hospital';

  @override
  String get addAllergy => 'Add Allergy';

  @override
  String get allergen => 'Allergen';

  @override
  String get reaction => 'Reaction';

  @override
  String get addMedication => 'Add Medication';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get dosage => 'Dosage';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get pending => 'Pending';

  @override
  String get partiallyDispensed => 'Partially Dispensed';

  @override
  String get fullyDispensed => 'Fully Dispensed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get noNotifications => 'No notifications';

  @override
  String notificationTitle(Object index) {
    return 'Notification $index';
  }

  @override
  String notificationDetail(Object index) {
    return 'This is a detail for notification $index. Your prescription is ready.';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String get login => 'Login';

  @override
  String loginFailed(Object error) {
    return 'Login Failed: $error';
  }

  @override
  String get loginSuccessful => 'Login Successful';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToAccount => 'Sign in to your account';

  @override
  String get nationalId => 'National ID';

  @override
  String get password => 'Password';

  @override
  String get invalidId => 'Invalid ID';

  @override
  String get tooShort => 'Too short';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get newAccount => 'New Account';

  @override
  String get whoAreYou => 'Who are you?';

  @override
  String get patientRole => 'Patient';

  @override
  String get doctorRole => 'Doctor';

  @override
  String get pharmacistRole => 'Pharmacist';

  @override
  String get patientRegistration => 'Patient Registration';

  @override
  String get doctorRegistration => 'Doctor Registration';

  @override
  String get pharmacistRegistration => 'Pharmacist Registration';

  @override
  String get registrationSuccessful => 'Registration Successful';

  @override
  String get registrationSubmitted => 'Registration Submitted';

  @override
  String get patientCodeTitle => 'Your Patient Code:';

  @override
  String get saveCodeNote =>
      'Save this code! You can use it to login along with your National ID.';

  @override
  String get goToLogin => 'Go to Login';

  @override
  String get createPatientAccount => 'Create Patient Account';

  @override
  String get completeEssentialsNote =>
      'Complete these essentials fields to get started';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get dobOptional => 'Date of Birth (Optional)';

  @override
  String get dobHint => 'Defaults to today if empty';

  @override
  String get phoneNumberOptional => 'Phone Number (Optional)';

  @override
  String get emailOptional => 'Email (Optional)';

  @override
  String get register => 'Register';

  @override
  String get postRegistrationNote =>
      'After registration, you can complete your medical profile in your dashboard.';

  @override
  String get joinAsSpecialist => 'Join as a Specialist';

  @override
  String get specialization => 'Specialization';

  @override
  String get licenseNumber => 'License Number';

  @override
  String get licenseDocumentUrl => 'License Document URL';

  @override
  String get professionalInformation => 'Professional Information';

  @override
  String get pharmacyName => 'Pharmacy Name';

  @override
  String get pendingApprovalNote =>
      'Your registration is pending admin approval. You will be notified once approved.';

  @override
  String get invalidUrl => 'Invalid URL';

  @override
  String get ok => 'OK';

  @override
  String get findPatient => 'Find Patient';

  @override
  String get searchHint => 'National ID or Patient Code';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get recentPatients => 'Recent Patients';

  @override
  String get messages => 'Messages';

  @override
  String get scanQR => 'Scan QR';

  @override
  String get simulateScan => 'Simulate Scan';

  @override
  String get cameraNotAvailable =>
      'Camera not available in simulator. Enter code manually to simulate scan result:';

  @override
  String get qrCodeData => 'QR Code Data';

  @override
  String get simulateRead => 'Simulate Read';

  @override
  String patientCodeLabel(Object code) {
    return 'Patient Code: $code';
  }

  @override
  String nationalIdLabel(Object id) {
    return 'National ID: $id';
  }

  @override
  String bloodTypeLabel(Object type) {
    return 'Blood Type: $type';
  }

  @override
  String get searchPatientInstruction =>
      'Search for a patient to view their medical record';

  @override
  String drPrefix(Object name) {
    return 'Dr. $name';
  }

  @override
  String get doctor => 'Doctor';

  @override
  String get patientDetails => 'Patient Details';

  @override
  String codeLabel(Object code) {
    return 'Code: $code';
  }

  @override
  String get age => 'Age';

  @override
  String get blood => 'Blood';

  @override
  String get addRecord => 'Add Record';

  @override
  String get addRx => 'Add Rx';

  @override
  String get criticalInformation => 'Critical Information';

  @override
  String get medicalHistoryTitle => 'Medical History';

  @override
  String get prescriptionsTitle => 'Prescriptions';

  @override
  String get noRecordsFound => 'No medical records found';

  @override
  String get noPrescriptionsFound =>
      'Search for a patient to view prescriptions';

  @override
  String prescriptionNumber(Object id) {
    return 'Prescription #$id';
  }

  @override
  String doctorLabel(Object name) {
    return 'Doctor: $name';
  }

  @override
  String dateLabel(Object date) {
    return 'Date: $date';
  }

  @override
  String get symptoms => 'Symptoms';

  @override
  String get treatment => 'Treatment';

  @override
  String get notes => 'Notes';

  @override
  String get close => 'Close';

  @override
  String get addMedicalRecord => 'Add Medical Record';

  @override
  String patientLabel(Object name) {
    return 'Patient: $name';
  }

  @override
  String get diagnosis => 'Diagnosis';

  @override
  String get diagnosisRequired => 'Please enter diagnosis';

  @override
  String get symptomsLabel => 'Symptoms';

  @override
  String get treatmentPlan => 'Treatment Plan';

  @override
  String get saveRecord => 'Save Record';

  @override
  String get recordAddedSuccessfully => 'Medical record added successfully';

  @override
  String get newPrescription => 'New Prescription';

  @override
  String get medicationsTitle => 'Medications';

  @override
  String get noMedicationsAdded => 'No medications added';

  @override
  String get createPrescription => 'Create Prescription';

  @override
  String get prescriptionCreatedSuccessfully =>
      'Prescription created successfully';

  @override
  String get atLeastOneMedication => 'Please add at least one medication';

  @override
  String get dosageLabel => 'Dosage (e.g. 500mg)';

  @override
  String get frequencyLabel => 'Frequency (e.g. 2x daily)';

  @override
  String get durationLabel => 'Duration (e.g. 5 days)';

  @override
  String get instructionsLabel => 'Instructions';

  @override
  String get doctorProfile => 'Doctor Profile';

  @override
  String get generalPractitioner => 'General Practitioner';

  @override
  String get licenseNumberLabel => 'License Number';

  @override
  String get hospitalLabel => 'Hospital';

  @override
  String get emailLabel => 'Email';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get findPrescription => 'Find Prescription';

  @override
  String get searchPrescriptionHint => 'Patient Code or National ID';

  @override
  String get dispensedToday => 'Dispensed Today';

  @override
  String searchResultsWithCount(Object count) {
    return 'Search Results ($count)';
  }

  @override
  String medicationsCount(Object count) {
    return '$count medications';
  }

  @override
  String get history => 'History';

  @override
  String get qrScannerSoon => 'QR Scanner coming soon';

  @override
  String get historySoon => 'History coming soon';

  @override
  String get dispensePrescription => 'Dispense Prescription';

  @override
  String get checkInteractions => 'Check Interactions';

  @override
  String get needMedicationsForInteraction =>
      'Need at least 2 medications to check for interactions';

  @override
  String get drugInteractions => 'Drug Interactions';

  @override
  String get noInteractionsFound => 'No interactions found.';

  @override
  String severityLabel(Object severity) {
    return 'Severity: $severity';
  }

  @override
  String recommendationLabel(Object recommendation) {
    return 'Recommendation: $recommendation';
  }

  @override
  String get selectItemsToDispense => 'Please select items to dispense';

  @override
  String get medicationsDispensedSuccess =>
      'Medications dispensed successfully';

  @override
  String dosageLabelDispense(Object dosage) {
    return 'Dosage: $dosage';
  }

  @override
  String instructionsLabelDispense(Object instructions) {
    return 'Instructions: $instructions';
  }

  @override
  String get dispenseSelected => 'Dispense Selected';

  @override
  String get pharmacistProfile => 'Pharmacist Profile';

  @override
  String get pharmacist => 'Pharmacist';

  @override
  String get statusLabel => 'Status';

  @override
  String get addDiagnosis => 'Add Diagnosis';

  @override
  String get addDiagnosisInstruction =>
      'Add medical diagnosis and notes for this patient';

  @override
  String get diagnosisFieldHint => 'Enter primary diagnosis';

  @override
  String get clinicalNotesOptional => 'Clinical Notes (Optional)';

  @override
  String get notesFieldHint =>
      'Additional notes, observations, recommendations...';

  @override
  String get saving => 'Saving...';

  @override
  String get incompleteProfileMessage =>
      'Your medical profile is incomplete. Please initialize it now to access all features.';

  @override
  String get needEmergencyHelp => 'Need emergency help?';

  @override
  String get emergencyNote => 'Show your emergency code to paramedics';

  @override
  String get emergencyDataAction => 'Emergency Data';

  @override
  String get qrCodeAction => 'QR Code';

  @override
  String get medicalRecordDetails => 'Medical Record Details';

  @override
  String get managingDoctor => 'Attending Doctor';

  @override
  String get prescriptionDetails => 'Prescription Details';

  @override
  String frequencyLabelValue(Object value) {
    return 'Frequency: $value';
  }

  @override
  String durationLabelValue(Object value) {
    return 'Duration: $value';
  }

  @override
  String get scanQrNote =>
      'Scan this QR code to access medical history in emergency';

  @override
  String get emergencyQrCode => 'Emergency QR Code';

  @override
  String get generatedByApp => 'Generated by Medical Record App';

  @override
  String get kg => 'kg';

  @override
  String get cm => 'cm';

  @override
  String get listSeparator => ', ';

  @override
  String get patientNotFound => 'Patient not found';

  @override
  String get prescriptionNotFound => 'Prescription not found';

  @override
  String get errorTitle => 'Error';

  @override
  String get unitLabel => 'Unit';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get updateStatus => 'Update Status';

  @override
  String get confirmStatusChange =>
      'Are you sure you want to change the status of this prescription?';

  @override
  String get optionalNotes => 'Optional notes...';

  @override
  String get statusUpdatedSuccess => 'Prescription status updated successfully';

  @override
  String get medicationAddedToPrescription =>
      'Medication added to prescription successfully';

  @override
  String get search => 'Search';

  @override
  String get markAsFullyDispensed => 'Mark as Fully Dispensed';

  @override
  String get cancelPrescription => 'Cancel Prescription';
}
