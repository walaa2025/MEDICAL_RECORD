import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Medical Record'**
  String get appTitle;

  /// A welcome message for the user
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeMessage(String name);

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @medicalRecords.
  ///
  /// In en, this message translates to:
  /// **'Medical Records'**
  String get medicalRecords;

  /// No description provided for @prescriptions.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get prescriptions;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @emergencyAlert.
  ///
  /// In en, this message translates to:
  /// **'Emergency Alert'**
  String get emergencyAlert;

  /// No description provided for @latestPrescriptions.
  ///
  /// In en, this message translates to:
  /// **'Latest Prescriptions'**
  String get latestPrescriptions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @initialize.
  ///
  /// In en, this message translates to:
  /// **'Initialize'**
  String get initialize;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get bloodType;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weight;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @emergencyPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency Phone'**
  String get emergencyPhone;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @completeProfileNote.
  ///
  /// In en, this message translates to:
  /// **'Note: You can see full medical details in the Emergency page.'**
  String get completeProfileNote;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No medical records found'**
  String get noRecords;

  /// No description provided for @recordNotFound.
  ///
  /// In en, this message translates to:
  /// **'Medical record not found'**
  String get recordNotFound;

  /// No description provided for @noPrescriptions.
  ///
  /// In en, this message translates to:
  /// **'No prescriptions found'**
  String get noPrescriptions;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(Object message);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get records;

  /// No description provided for @meds.
  ///
  /// In en, this message translates to:
  /// **'Meds'**
  String get meds;

  /// No description provided for @profileShort.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileShort;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Loading error'**
  String get loadingError;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFound;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfo;

  /// No description provided for @biometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get biometrics;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInfo;

  /// No description provided for @doctorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Dr. {name}'**
  String doctorPrefix(Object name);

  /// No description provided for @notesAvailable.
  ///
  /// In en, this message translates to:
  /// **'Notes Available'**
  String get notesAvailable;

  /// No description provided for @medicationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Medications:'**
  String get medicationsLabel;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @saveImageSuccess.
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery successfully'**
  String get saveImageSuccess;

  /// No description provided for @saveImageError.
  ///
  /// In en, this message translates to:
  /// **'Error saving image: {error}'**
  String saveImageError(Object error);

  /// No description provided for @saveAsImage.
  ///
  /// In en, this message translates to:
  /// **'Save as Image'**
  String get saveAsImage;

  /// No description provided for @emergencyCriticalNote.
  ///
  /// In en, this message translates to:
  /// **'Critical medical information - For emergency use only'**
  String get emergencyCriticalNote;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @noEmergencyInfo.
  ///
  /// In en, this message translates to:
  /// **'No emergency information found'**
  String get noEmergencyInfo;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @chronicDiseases.
  ///
  /// In en, this message translates to:
  /// **'Chronic Diseases'**
  String get chronicDiseases;

  /// No description provided for @currentMedications.
  ///
  /// In en, this message translates to:
  /// **'Current Medications'**
  String get currentMedications;

  /// No description provided for @surgeries.
  ///
  /// In en, this message translates to:
  /// **'Surgeries'**
  String get surgeries;

  /// No description provided for @selectBirthDateError.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth'**
  String get selectBirthDateError;

  /// No description provided for @medicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// No description provided for @medsAndAllergies.
  ///
  /// In en, this message translates to:
  /// **'Medications & Allergies'**
  String get medsAndAllergies;

  /// No description provided for @stepCounter.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepCounter(Object current, Object total);

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @noDataAdded.
  ///
  /// In en, this message translates to:
  /// **'No data added'**
  String get noDataAdded;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addChronicDisease.
  ///
  /// In en, this message translates to:
  /// **'Add Chronic Disease'**
  String get addChronicDisease;

  /// No description provided for @diseaseName.
  ///
  /// In en, this message translates to:
  /// **'Disease Name'**
  String get diseaseName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @addSurgery.
  ///
  /// In en, this message translates to:
  /// **'Add Surgery'**
  String get addSurgery;

  /// No description provided for @surgeryName.
  ///
  /// In en, this message translates to:
  /// **'Surgery Name'**
  String get surgeryName;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospital;

  /// No description provided for @addAllergy.
  ///
  /// In en, this message translates to:
  /// **'Add Allergy'**
  String get addAllergy;

  /// No description provided for @allergen.
  ///
  /// In en, this message translates to:
  /// **'Allergen'**
  String get allergen;

  /// No description provided for @reaction.
  ///
  /// In en, this message translates to:
  /// **'Reaction'**
  String get reaction;

  /// No description provided for @addMedication.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get addMedication;

  /// No description provided for @medicationName.
  ///
  /// In en, this message translates to:
  /// **'Medication Name'**
  String get medicationName;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @partiallyDispensed.
  ///
  /// In en, this message translates to:
  /// **'Partially Dispensed'**
  String get partiallyDispensed;

  /// No description provided for @fullyDispensed.
  ///
  /// In en, this message translates to:
  /// **'Fully Dispensed'**
  String get fullyDispensed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification {index}'**
  String notificationTitle(Object index);

  /// No description provided for @notificationDetail.
  ///
  /// In en, this message translates to:
  /// **'This is a detail for notification {index}. Your prescription is ready.'**
  String notificationDetail(Object index);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(Object count);

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed: {error}'**
  String loginFailed(Object error);

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login Successful'**
  String get loginSuccessful;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToAccount;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @invalidId.
  ///
  /// In en, this message translates to:
  /// **'Invalid ID'**
  String get invalidId;

  /// No description provided for @tooShort.
  ///
  /// In en, this message translates to:
  /// **'Too short'**
  String get tooShort;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newAccount;

  /// No description provided for @whoAreYou.
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get whoAreYou;

  /// No description provided for @patientRole.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patientRole;

  /// No description provided for @doctorRole.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctorRole;

  /// No description provided for @pharmacistRole.
  ///
  /// In en, this message translates to:
  /// **'Pharmacist'**
  String get pharmacistRole;

  /// No description provided for @patientRegistration.
  ///
  /// In en, this message translates to:
  /// **'Patient Registration'**
  String get patientRegistration;

  /// No description provided for @doctorRegistration.
  ///
  /// In en, this message translates to:
  /// **'Doctor Registration'**
  String get doctorRegistration;

  /// No description provided for @pharmacistRegistration.
  ///
  /// In en, this message translates to:
  /// **'Pharmacist Registration'**
  String get pharmacistRegistration;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get registrationSuccessful;

  /// No description provided for @registrationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Registration Submitted'**
  String get registrationSubmitted;

  /// No description provided for @patientCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Patient Code:'**
  String get patientCodeTitle;

  /// No description provided for @saveCodeNote.
  ///
  /// In en, this message translates to:
  /// **'Save this code! You can use it to login along with your National ID.'**
  String get saveCodeNote;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// No description provided for @createPatientAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Patient Account'**
  String get createPatientAccount;

  /// No description provided for @completeEssentialsNote.
  ///
  /// In en, this message translates to:
  /// **'Complete these essentials fields to get started'**
  String get completeEssentialsNote;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @dobOptional.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth (Optional)'**
  String get dobOptional;

  /// No description provided for @dobHint.
  ///
  /// In en, this message translates to:
  /// **'Defaults to today if empty'**
  String get dobHint;

  /// No description provided for @phoneNumberOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone Number (Optional)'**
  String get phoneNumberOptional;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailOptional;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @postRegistrationNote.
  ///
  /// In en, this message translates to:
  /// **'After registration, you can complete your medical profile in your dashboard.'**
  String get postRegistrationNote;

  /// No description provided for @joinAsSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Join as a Specialist'**
  String get joinAsSpecialist;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @licenseNumber.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get licenseNumber;

  /// No description provided for @licenseDocumentUrl.
  ///
  /// In en, this message translates to:
  /// **'License Document URL'**
  String get licenseDocumentUrl;

  /// No description provided for @professionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get professionalInformation;

  /// No description provided for @pharmacyName.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Name'**
  String get pharmacyName;

  /// No description provided for @pendingApprovalNote.
  ///
  /// In en, this message translates to:
  /// **'Your registration is pending admin approval. You will be notified once approved.'**
  String get pendingApprovalNote;

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL'**
  String get invalidUrl;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @findPatient.
  ///
  /// In en, this message translates to:
  /// **'Find Patient'**
  String get findPatient;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'National ID or Patient Code'**
  String get searchHint;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @recentPatients.
  ///
  /// In en, this message translates to:
  /// **'Recent Patients'**
  String get recentPatients;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @scanQR.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQR;

  /// No description provided for @simulateScan.
  ///
  /// In en, this message translates to:
  /// **'Simulate Scan'**
  String get simulateScan;

  /// No description provided for @cameraNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Camera not available in simulator. Enter code manually to simulate scan result:'**
  String get cameraNotAvailable;

  /// No description provided for @qrCodeData.
  ///
  /// In en, this message translates to:
  /// **'QR Code Data'**
  String get qrCodeData;

  /// No description provided for @simulateRead.
  ///
  /// In en, this message translates to:
  /// **'Simulate Read'**
  String get simulateRead;

  /// No description provided for @patientCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient Code: {code}'**
  String patientCodeLabel(Object code);

  /// No description provided for @nationalIdLabel.
  ///
  /// In en, this message translates to:
  /// **'National ID: {id}'**
  String nationalIdLabel(Object id);

  /// No description provided for @bloodTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood Type: {type}'**
  String bloodTypeLabel(Object type);

  /// No description provided for @searchPatientInstruction.
  ///
  /// In en, this message translates to:
  /// **'Search for a patient to view their medical record'**
  String get searchPatientInstruction;

  /// No description provided for @drPrefix.
  ///
  /// In en, this message translates to:
  /// **'Dr. {name}'**
  String drPrefix(Object name);

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @patientDetails.
  ///
  /// In en, this message translates to:
  /// **'Patient Details'**
  String get patientDetails;

  /// No description provided for @codeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code: {code}'**
  String codeLabel(Object code);

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @blood.
  ///
  /// In en, this message translates to:
  /// **'Blood'**
  String get blood;

  /// No description provided for @addRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get addRecord;

  /// No description provided for @addRx.
  ///
  /// In en, this message translates to:
  /// **'Add Rx'**
  String get addRx;

  /// No description provided for @criticalInformation.
  ///
  /// In en, this message translates to:
  /// **'Critical Information'**
  String get criticalInformation;

  /// No description provided for @medicalHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistoryTitle;

  /// No description provided for @prescriptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get prescriptionsTitle;

  /// No description provided for @noRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No medical records found'**
  String get noRecordsFound;

  /// No description provided for @noPrescriptionsFound.
  ///
  /// In en, this message translates to:
  /// **'Search for a patient to view prescriptions'**
  String get noPrescriptionsFound;

  /// No description provided for @prescriptionNumber.
  ///
  /// In en, this message translates to:
  /// **'Prescription #{id}'**
  String prescriptionNumber(Object id);

  /// No description provided for @doctorLabel.
  ///
  /// In en, this message translates to:
  /// **'Doctor: {name}'**
  String doctorLabel(Object name);

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateLabel(Object date);

  /// No description provided for @symptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatment;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @addMedicalRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Medical Record'**
  String get addMedicalRecord;

  /// No description provided for @patientLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient: {name}'**
  String patientLabel(Object name);

  /// No description provided for @diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosis;

  /// No description provided for @diagnosisRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter diagnosis'**
  String get diagnosisRequired;

  /// No description provided for @symptomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptomsLabel;

  /// No description provided for @treatmentPlan.
  ///
  /// In en, this message translates to:
  /// **'Treatment Plan'**
  String get treatmentPlan;

  /// No description provided for @saveRecord.
  ///
  /// In en, this message translates to:
  /// **'Save Record'**
  String get saveRecord;

  /// No description provided for @recordAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Medical record added successfully'**
  String get recordAddedSuccessfully;

  /// No description provided for @newPrescription.
  ///
  /// In en, this message translates to:
  /// **'New Prescription'**
  String get newPrescription;

  /// No description provided for @medicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medicationsTitle;

  /// No description provided for @noMedicationsAdded.
  ///
  /// In en, this message translates to:
  /// **'No medications added'**
  String get noMedicationsAdded;

  /// No description provided for @createPrescription.
  ///
  /// In en, this message translates to:
  /// **'Create Prescription'**
  String get createPrescription;

  /// No description provided for @prescriptionCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Prescription created successfully'**
  String get prescriptionCreatedSuccessfully;

  /// No description provided for @atLeastOneMedication.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one medication'**
  String get atLeastOneMedication;

  /// No description provided for @dosageLabel.
  ///
  /// In en, this message translates to:
  /// **'Dosage (e.g. 500mg)'**
  String get dosageLabel;

  /// No description provided for @frequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency (e.g. 2x daily)'**
  String get frequencyLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (e.g. 5 days)'**
  String get durationLabel;

  /// No description provided for @instructionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructionsLabel;

  /// No description provided for @doctorProfile.
  ///
  /// In en, this message translates to:
  /// **'Doctor Profile'**
  String get doctorProfile;

  /// No description provided for @generalPractitioner.
  ///
  /// In en, this message translates to:
  /// **'General Practitioner'**
  String get generalPractitioner;

  /// No description provided for @licenseNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get licenseNumberLabel;

  /// No description provided for @hospitalLabel.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospitalLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @findPrescription.
  ///
  /// In en, this message translates to:
  /// **'Find Prescription'**
  String get findPrescription;

  /// No description provided for @searchPrescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Patient Code or National ID'**
  String get searchPrescriptionHint;

  /// No description provided for @dispensedToday.
  ///
  /// In en, this message translates to:
  /// **'Dispensed Today'**
  String get dispensedToday;

  /// No description provided for @searchResultsWithCount.
  ///
  /// In en, this message translates to:
  /// **'Search Results ({count})'**
  String searchResultsWithCount(Object count);

  /// No description provided for @medicationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} medications'**
  String medicationsCount(Object count);

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @qrScannerSoon.
  ///
  /// In en, this message translates to:
  /// **'QR Scanner coming soon'**
  String get qrScannerSoon;

  /// No description provided for @historySoon.
  ///
  /// In en, this message translates to:
  /// **'History coming soon'**
  String get historySoon;

  /// No description provided for @dispensePrescription.
  ///
  /// In en, this message translates to:
  /// **'Dispense Prescription'**
  String get dispensePrescription;

  /// No description provided for @checkInteractions.
  ///
  /// In en, this message translates to:
  /// **'Check Interactions'**
  String get checkInteractions;

  /// No description provided for @needMedicationsForInteraction.
  ///
  /// In en, this message translates to:
  /// **'Need at least 2 medications to check for interactions'**
  String get needMedicationsForInteraction;

  /// No description provided for @drugInteractions.
  ///
  /// In en, this message translates to:
  /// **'Drug Interactions'**
  String get drugInteractions;

  /// No description provided for @noInteractionsFound.
  ///
  /// In en, this message translates to:
  /// **'No interactions found.'**
  String get noInteractionsFound;

  /// No description provided for @severityLabel.
  ///
  /// In en, this message translates to:
  /// **'Severity: {severity}'**
  String severityLabel(Object severity);

  /// No description provided for @recommendationLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommendation: {recommendation}'**
  String recommendationLabel(Object recommendation);

  /// No description provided for @selectItemsToDispense.
  ///
  /// In en, this message translates to:
  /// **'Please select items to dispense'**
  String get selectItemsToDispense;

  /// No description provided for @medicationsDispensedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Medications dispensed successfully'**
  String get medicationsDispensedSuccess;

  /// No description provided for @dosageLabelDispense.
  ///
  /// In en, this message translates to:
  /// **'Dosage: {dosage}'**
  String dosageLabelDispense(Object dosage);

  /// No description provided for @instructionsLabelDispense.
  ///
  /// In en, this message translates to:
  /// **'Instructions: {instructions}'**
  String instructionsLabelDispense(Object instructions);

  /// No description provided for @dispenseSelected.
  ///
  /// In en, this message translates to:
  /// **'Dispense Selected'**
  String get dispenseSelected;

  /// No description provided for @pharmacistProfile.
  ///
  /// In en, this message translates to:
  /// **'Pharmacist Profile'**
  String get pharmacistProfile;

  /// No description provided for @pharmacist.
  ///
  /// In en, this message translates to:
  /// **'Pharmacist'**
  String get pharmacist;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @addDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Add Diagnosis'**
  String get addDiagnosis;

  /// No description provided for @addDiagnosisInstruction.
  ///
  /// In en, this message translates to:
  /// **'Add medical diagnosis and notes for this patient'**
  String get addDiagnosisInstruction;

  /// No description provided for @diagnosisFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter primary diagnosis'**
  String get diagnosisFieldHint;

  /// No description provided for @clinicalNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Clinical Notes (Optional)'**
  String get clinicalNotesOptional;

  /// No description provided for @notesFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Additional notes, observations, recommendations...'**
  String get notesFieldHint;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @incompleteProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'Your medical profile is incomplete. Please initialize it now to access all features.'**
  String get incompleteProfileMessage;

  /// No description provided for @needEmergencyHelp.
  ///
  /// In en, this message translates to:
  /// **'Need emergency help?'**
  String get needEmergencyHelp;

  /// No description provided for @emergencyNote.
  ///
  /// In en, this message translates to:
  /// **'Show your emergency code to paramedics'**
  String get emergencyNote;

  /// No description provided for @emergencyDataAction.
  ///
  /// In en, this message translates to:
  /// **'Emergency Data'**
  String get emergencyDataAction;

  /// No description provided for @qrCodeAction.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCodeAction;

  /// No description provided for @medicalRecordDetails.
  ///
  /// In en, this message translates to:
  /// **'Medical Record Details'**
  String get medicalRecordDetails;

  /// No description provided for @managingDoctor.
  ///
  /// In en, this message translates to:
  /// **'Attending Doctor'**
  String get managingDoctor;

  /// No description provided for @prescriptionDetails.
  ///
  /// In en, this message translates to:
  /// **'Prescription Details'**
  String get prescriptionDetails;

  /// No description provided for @frequencyLabelValue.
  ///
  /// In en, this message translates to:
  /// **'Frequency: {value}'**
  String frequencyLabelValue(Object value);

  /// No description provided for @durationLabelValue.
  ///
  /// In en, this message translates to:
  /// **'Duration: {value}'**
  String durationLabelValue(Object value);

  /// No description provided for @scanQrNote.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code to access medical history in emergency'**
  String get scanQrNote;

  /// No description provided for @emergencyQrCode.
  ///
  /// In en, this message translates to:
  /// **'Emergency QR Code'**
  String get emergencyQrCode;

  /// No description provided for @generatedByApp.
  ///
  /// In en, this message translates to:
  /// **'Generated by Medical Record App'**
  String get generatedByApp;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @listSeparator.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get listSeparator;

  /// No description provided for @patientNotFound.
  ///
  /// In en, this message translates to:
  /// **'Patient not found'**
  String get patientNotFound;

  /// No description provided for @prescriptionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Prescription not found'**
  String get prescriptionNotFound;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @updateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get updateStatus;

  /// No description provided for @confirmStatusChange.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to change the status of this prescription?'**
  String get confirmStatusChange;

  /// No description provided for @optionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Optional notes...'**
  String get optionalNotes;

  /// No description provided for @statusUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Prescription status updated successfully'**
  String get statusUpdatedSuccess;

  /// No description provided for @medicationAddedToPrescription.
  ///
  /// In en, this message translates to:
  /// **'Medication added to prescription successfully'**
  String get medicationAddedToPrescription;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @markAsFullyDispensed.
  ///
  /// In en, this message translates to:
  /// **'Mark as Fully Dispensed'**
  String get markAsFullyDispensed;

  /// No description provided for @cancelPrescription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Prescription'**
  String get cancelPrescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
