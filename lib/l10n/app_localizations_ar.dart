// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'السجل الطبي';

  @override
  String welcomeMessage(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get dashboard => 'الرئيسية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get medicalRecords => 'السجل الطبي';

  @override
  String get prescriptions => 'الوصفات الطبية';

  @override
  String get emergency => 'الطوارئ';

  @override
  String get notifications => 'التنبيهات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get settings => 'الإعدادات';

  @override
  String get theme => 'المظهر';

  @override
  String get language => 'اللغة';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get quickActions => 'الوصول السريع';

  @override
  String get emergencyAlert => 'حالة الطوارئ';

  @override
  String get latestPrescriptions => 'أحدث الوصفات';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get initialize => 'تهيئة';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get gender => 'الجنس';

  @override
  String get bloodType => 'فصيلة الدم';

  @override
  String get height => 'الطول (سم)';

  @override
  String get weight => 'الوزن (كجم)';

  @override
  String get address => 'العنوان';

  @override
  String get emergencyContact => 'جهة اتصال الطوارئ';

  @override
  String get emergencyPhone => 'هاتف الطوارئ';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get completeProfileNote =>
      'ملاحظة: يمكنك رؤية التفاصيل الطبية الكاملة في صفحة الطوارئ.';

  @override
  String get noRecords => 'لا توجد سجلات طبية';

  @override
  String get recordNotFound => 'السجل الطبي غير موجود';

  @override
  String get noPrescriptions => 'لا توجد وصفات طبية';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String error(Object message) {
    return 'خطأ: $message';
  }

  @override
  String get home => 'الرئيسية';

  @override
  String get records => 'السجلات';

  @override
  String get meds => 'الوصفات';

  @override
  String get profileShort => 'الملف';

  @override
  String get logoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get loadingError => 'خطأ في التحميل';

  @override
  String get profileNotFound => 'الملف الشخصي غير موجود';

  @override
  String get basicInfo => 'المعلومات الأساسية';

  @override
  String get biometrics => 'القياسات الحيوية';

  @override
  String get contactInfo => 'معلومات التواصل';

  @override
  String doctorPrefix(Object name) {
    return 'د. $name';
  }

  @override
  String get notesAvailable => 'ملاحظات متوفرة';

  @override
  String get medicationsLabel => 'الأدوية:';

  @override
  String get required => 'مطلوب';

  @override
  String get profileUpdatedSuccess => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get saveImageSuccess => 'تم حفظ الصورة في المعرض بنجاح';

  @override
  String saveImageError(Object error) {
    return 'خطأ في حفظ الصورة: $error';
  }

  @override
  String get saveAsImage => 'حفظ كصورة';

  @override
  String get emergencyCriticalNote =>
      'معلومات طبية حرجة - للاستخدام في حالات الطوارئ فقط';

  @override
  String get notSpecified => 'غير محدد';

  @override
  String get noEmergencyInfo => 'لا توجد معلومات طوارئ';

  @override
  String get allergies => 'الحساسية';

  @override
  String get chronicDiseases => 'الأمراض المزمنة';

  @override
  String get currentMedications => 'الأدوية الحالية';

  @override
  String get surgeries => 'العمليات الجراحية';

  @override
  String get selectBirthDateError => 'الرجاء اختيار تاريخ الميلاد';

  @override
  String get medicalHistory => 'التاريخ الطبي';

  @override
  String get medsAndAllergies => 'الأدوية والحساسية';

  @override
  String stepCounter(Object current, Object total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get additionalNotes => 'ملاحظات إضافية';

  @override
  String get noDataAdded => 'لا توجد بيانات مضافة';

  @override
  String get previous => 'السابق';

  @override
  String get next => 'التالي';

  @override
  String get submit => 'إرسال';

  @override
  String get add => 'إضافة';

  @override
  String get addChronicDisease => 'إضافة مرض مزمن';

  @override
  String get diseaseName => 'اسم المرض';

  @override
  String get description => 'الوصف';

  @override
  String get addSurgery => 'إضافة عملية جراحية';

  @override
  String get surgeryName => 'اسم العملية';

  @override
  String get hospital => 'المستشفى';

  @override
  String get addAllergy => 'إضافة حساسية';

  @override
  String get allergen => 'المادة المسببة';

  @override
  String get reaction => 'رد الفعل';

  @override
  String get addMedication => 'إضافة دواء';

  @override
  String get medicationName => 'اسم الدواء';

  @override
  String get dosage => 'الجرعة';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get partiallyDispensed => 'تم الصرف جزئياً';

  @override
  String get fullyDispensed => 'تم الصرف بالكامل';

  @override
  String get cancelled => 'ملغي';

  @override
  String get noNotifications => 'لا توجد تنبيهات';

  @override
  String notificationTitle(Object index) {
    return 'تنبيه $index';
  }

  @override
  String notificationDetail(Object index) {
    return 'هذا تفصيل للتنبيه $index. وصفتك الطبية جاهزة.';
  }

  @override
  String hoursAgo(Object count) {
    return 'قبل $count ساعة';
  }

  @override
  String get login => 'تسجيل الدخول';

  @override
  String loginFailed(Object error) {
    return 'فشل تسجيل الدخول: $error';
  }

  @override
  String get loginSuccessful => 'تم تسجيل الدخول بنجاح';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInToAccount => 'قم بتسجيل الدخول إلى حسابك';

  @override
  String get nationalId => 'الرقم القومي';

  @override
  String get password => 'كلمة المرور';

  @override
  String get invalidId => 'رقم قومي غير صالح';

  @override
  String get tooShort => 'قصير جداً';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get newAccount => 'حساب جديد';

  @override
  String get whoAreYou => 'من أنت؟';

  @override
  String get patientRole => 'مريض';

  @override
  String get doctorRole => 'طبيب';

  @override
  String get pharmacistRole => 'صيدلي';

  @override
  String get patientRegistration => 'تسجيل مريض';

  @override
  String get doctorRegistration => 'تسجيل طبيب';

  @override
  String get pharmacistRegistration => 'تسجيل صيدلي';

  @override
  String get registrationSuccessful => 'تم التسجيل بنجاح!';

  @override
  String get registrationSubmitted => 'تم إرسال الطلب';

  @override
  String get patientCodeTitle => 'كود المريض الخاص بك:';

  @override
  String get saveCodeNote =>
      'احفظ هذا الكود! يمكنك استخدامه لتسجيل الدخول مع رقمك القومي.';

  @override
  String get goToLogin => 'الذهاب لتسجيل الدخول';

  @override
  String get createPatientAccount => 'إنشاء حساب مريض';

  @override
  String get completeEssentialsNote => 'أكمل هذه الحقول الأساسية للبدء';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordMismatch => 'كلمات المرور غير متطابقة';

  @override
  String get dobOptional => 'تاريخ الميلاد (اختياري)';

  @override
  String get dobHint => 'سيتم ضبطه على تاريخ اليوم إذا ترك فارغاً';

  @override
  String get phoneNumberOptional => 'رقم الهاتف (اختياري)';

  @override
  String get emailOptional => 'البريد الإلكتروني (اختياري)';

  @override
  String get register => 'تسجيل';

  @override
  String get postRegistrationNote =>
      'بعد التسجيل، يمكنك إكمال ملفك الطبي من لوحة التحكم الخاصة بك.';

  @override
  String get joinAsSpecialist => 'انضم كمتخصص';

  @override
  String get specialization => 'التخصص';

  @override
  String get licenseNumber => 'رقم الترخيص';

  @override
  String get licenseDocumentUrl => 'رابط وثيقة الترخيص';

  @override
  String get professionalInformation => 'المعلومات المهنية';

  @override
  String get pharmacyName => 'اسم الصيدلية';

  @override
  String get pendingApprovalNote =>
      'طلبك قيد المراجعة من قبل المسؤول. سيتم إخطارك فور الموافقة.';

  @override
  String get invalidUrl => 'رابط غير صالح';

  @override
  String get ok => 'حسناً';

  @override
  String get findPatient => 'البحث عن مريض';

  @override
  String get searchHint => 'الرقم القومي أو كود المريض';

  @override
  String get quickAccess => 'الوصول السريع';

  @override
  String get recentPatients => 'المرضى الأخيرون';

  @override
  String get messages => 'الرسائل';

  @override
  String get scanQR => 'مسح رمز QR';

  @override
  String get simulateScan => 'محاكاة المسح';

  @override
  String get cameraNotAvailable =>
      'الكاميرا غير متوفرة في المحاكي. أدخل الكود يدوياً لمحاكاة نتيجة المسح:';

  @override
  String get qrCodeData => 'بيانات رمز QR';

  @override
  String get simulateRead => 'محاكاة القراءة';

  @override
  String patientCodeLabel(Object code) {
    return 'كود المريض: $code';
  }

  @override
  String nationalIdLabel(Object id) {
    return 'الرقم القومي: $id';
  }

  @override
  String bloodTypeLabel(Object type) {
    return 'فصيلة الدم: $type';
  }

  @override
  String get searchPatientInstruction => 'ابحث عن مريض لعرض سجله الطبي';

  @override
  String drPrefix(Object name) {
    return 'د. $name';
  }

  @override
  String get doctor => 'طبيب';

  @override
  String get patientDetails => 'تفاصيل المريض';

  @override
  String codeLabel(Object code) {
    return 'الكود: $code';
  }

  @override
  String get age => 'العمر';

  @override
  String get blood => 'الفصيلة';

  @override
  String get addRecord => 'إضافة سجل';

  @override
  String get addRx => 'إضافة وصفة';

  @override
  String get criticalInformation => 'معلومات هامة';

  @override
  String get medicalHistoryTitle => 'التاريخ الطبي';

  @override
  String get prescriptionsTitle => 'الوصفات الطبية';

  @override
  String get noRecordsFound => 'لا توجد سجلات طبية';

  @override
  String get noPrescriptionsFound => 'ابحث عن مريض لعرض الوصفات الطبية';

  @override
  String prescriptionNumber(Object id) {
    return 'وصفة رقم $id';
  }

  @override
  String doctorLabel(Object name) {
    return 'الطبيب: $name';
  }

  @override
  String dateLabel(Object date) {
    return 'التاريخ: $date';
  }

  @override
  String get symptoms => 'الأعراض';

  @override
  String get treatment => 'العلاج';

  @override
  String get notes => 'ملاحظات';

  @override
  String get close => 'إغلاق';

  @override
  String get addMedicalRecord => 'إضافة سجل طبي';

  @override
  String patientLabel(Object name) {
    return 'المريض: $name';
  }

  @override
  String get diagnosis => 'التشخيص';

  @override
  String get diagnosisRequired => 'يرجى إدخال التشخيص';

  @override
  String get symptomsLabel => 'الأعراض';

  @override
  String get treatmentPlan => 'خطة العلاج';

  @override
  String get saveRecord => 'حفظ السجل';

  @override
  String get recordAddedSuccessfully => 'تم إضافة السجل الطبي بنجاح';

  @override
  String get newPrescription => 'وصفة طبية جديدة';

  @override
  String get medicationsTitle => 'الأدوية';

  @override
  String get noMedicationsAdded => 'لم يتم إضافة أدوية';

  @override
  String get createPrescription => 'إنشاء وصفة';

  @override
  String get prescriptionCreatedSuccessfully => 'تم إنشاء الوصفة بنجاح';

  @override
  String get atLeastOneMedication => 'يرجى إضافة دواء واحد على الأقل';

  @override
  String get dosageLabel => 'الجرعة (مثلاً: 500 ملجم)';

  @override
  String get frequencyLabel => 'التكرار (مثلاً: مرتين يومياً)';

  @override
  String get durationLabel => 'المدة (مثلاً: 5 أيام)';

  @override
  String get instructionsLabel => 'التعليمات';

  @override
  String get doctorProfile => 'ملف الطبيب';

  @override
  String get generalPractitioner => 'ممارس عام';

  @override
  String get licenseNumberLabel => 'رقم الترخيص';

  @override
  String get hospitalLabel => 'المستشفى';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get findPrescription => 'البحث عن وصفة';

  @override
  String get searchPrescriptionHint => 'كود المريض أو الرقم القومي';

  @override
  String get dispensedToday => 'صُرف اليوم';

  @override
  String searchResultsWithCount(Object count) {
    return 'نتائج البحث ($count)';
  }

  @override
  String medicationsCount(Object count) {
    return '$count أدوية';
  }

  @override
  String get history => 'السجل';

  @override
  String get qrScannerSoon => 'ماسح QR قادم قريباً';

  @override
  String get historySoon => 'السجل قادم قريباً';

  @override
  String get dispensePrescription => 'صرف الوصفة';

  @override
  String get checkInteractions => 'فحص التداخلات';

  @override
  String get needMedicationsForInteraction =>
      'تحتاج إلى دواءين على الأقل لفحص التداخلات';

  @override
  String get drugInteractions => 'التداخلات الدوائية';

  @override
  String get noInteractionsFound => 'لم يتم العثور على تداخلات.';

  @override
  String severityLabel(Object severity) {
    return 'الخطورة: $severity';
  }

  @override
  String recommendationLabel(Object recommendation) {
    return 'التوصية: $recommendation';
  }

  @override
  String get selectItemsToDispense => 'يرجى اختيار الأدوية المراد صرفها';

  @override
  String get medicationsDispensedSuccess => 'تم صرف الأدوية بنجاح';

  @override
  String dosageLabelDispense(Object dosage) {
    return 'الجرعة: $dosage';
  }

  @override
  String instructionsLabelDispense(Object instructions) {
    return 'التعليمات: $instructions';
  }

  @override
  String get dispenseSelected => 'صرف المختار';

  @override
  String get pharmacistProfile => 'ملف الصيدلي';

  @override
  String get pharmacist => 'صيدلي';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get addDiagnosis => 'إضافة تشخيص';

  @override
  String get addDiagnosisInstruction => 'إضافة تشخيص طبي وملاحظات لهذا المريض';

  @override
  String get diagnosisFieldHint => 'أدخل التشخيص الأساسي';

  @override
  String get clinicalNotesOptional => 'ملاحظات سريرية (اختياري)';

  @override
  String get notesFieldHint => 'ملاحظات إضافية، مشاهدات، توصيات...';

  @override
  String get saving => 'جاري الحفظ...';

  @override
  String get incompleteProfileMessage =>
      'ملفك الطبي غير مكتمل. يرجى تهيئته الآن للحصول على كامل المميزات.';

  @override
  String get needEmergencyHelp => 'هل تحتاج مساعدة طارئة؟';

  @override
  String get emergencyNote => 'اعرض كود الطوارئ الخاص بك للمسعفين';

  @override
  String get emergencyDataAction => 'بيانات الطوارئ';

  @override
  String get qrCodeAction => 'كود QR';

  @override
  String get medicalRecordDetails => 'تفاصيل السجل الطبي';

  @override
  String get managingDoctor => 'الطبيب المعالج';

  @override
  String get prescriptionDetails => 'تفاصيل الوصفة الطبية';

  @override
  String frequencyLabelValue(Object value) {
    return 'التكرار: $value';
  }

  @override
  String durationLabelValue(Object value) {
    return 'المدة: $value';
  }

  @override
  String get scanQrNote =>
      'امسح كود QR للوصول إلى السجل الطبي في حالات الطوارئ';

  @override
  String get emergencyQrCode => 'رمز الطوارئ QR';

  @override
  String get generatedByApp => 'تم إنشاؤه بواسطة تطبيق السجل الطبي';

  @override
  String get kg => 'كجم';

  @override
  String get cm => 'سم';

  @override
  String get listSeparator => '، ';

  @override
  String get patientNotFound => 'المريض غير موجود';

  @override
  String get prescriptionNotFound => 'الوصفة الطبية غير موجودة';

  @override
  String get errorTitle => 'خطأ';

  @override
  String get unitLabel => 'الوحدة';

  @override
  String get quantityLabel => 'الكمية';

  @override
  String get updateStatus => 'تحديث الحالة';

  @override
  String get confirmStatusChange =>
      'هل أنت متأكد من رغبتك في تغيير حالة هذه الوصفة؟';

  @override
  String get optionalNotes => 'ملاحظات اختيارية...';

  @override
  String get statusUpdatedSuccess => 'تم تحديث حالة الوصفة بنجاح';

  @override
  String get medicationAddedToPrescription =>
      'تم إضافة الدواء إلى الوصفة بنجاح';

  @override
  String get search => 'بحث';

  @override
  String get markAsFullyDispensed => 'تمييز كمنصرف بالكامل';

  @override
  String get cancelPrescription => 'إلغاء الوصفة';
}
