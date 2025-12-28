
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:midical_record/features/auth/data/models/auth_model.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/core/utils/validation_utils.dart';

/// Patient Sign-Up Screen
/// Simplified registration with essential fields only
/// After registration, patient completes profile in their dashboard
class PatientSignUpScreen extends ConsumerStatefulWidget {
  const PatientSignUpScreen({super.key});

  @override
  ConsumerState<PatientSignUpScreen> createState() => _PatientSignUpScreenState();
}

class _PatientSignUpScreenState extends ConsumerState<PatientSignUpScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final _nationalIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  // Track password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nationalIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _dobController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Show date picker for date of birth
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  /// Submit registration form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create patient registration model
      final patientData = PatientRegistrationModel(
        nationalId: _nationalIdController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        dateOfBirth: _dobController.text.isEmpty 
            ? null 
            : DateTime.parse(_dobController.text),
        phoneNumber: _phoneNumberController.text.trim().isEmpty 
            ? null 
            : _phoneNumberController.text.trim(),
        email: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
      );

      // Call the registration provider
      ref.read(signUpPatientControllerProvider.notifier).registerPatient(patientData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpPatientControllerProvider);
    final theme = Theme.of(context);

    // Listen to registration state changes
    ref.listen<AsyncValue<PatientRegistrationResponseModel?>>(
      signUpPatientControllerProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
           ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $error'),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          data: (response) {
            if (response != null && response.success) {
              // Show success dialog with patient code
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 32),
                      const SizedBox(width: 12),
                      Text(AppLocalizations.of(context)!.registrationSuccessful),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(response.message),
                      if (response.patientCode != null) ...[
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.primaryColor, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.patientCodeTitle,
                                style: theme.textTheme.labelMedium,
                              ),
                              SizedBox(height: 8),
                              Text(
                                response.patientCode!,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                AppLocalizations.of(context)!.saveCodeNote,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go('/login');
                      },
                      child: Text(AppLocalizations.of(context)!.goToLogin),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.patientRegistration),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.8),
              theme.colorScheme.secondary.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Icon(
                          Icons.person_add_alt_1,
                          size: 64,
                          color: theme.primaryColor,
                        ).animate().scale(duration: 600.ms).fadeIn(),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.createPatientAccount,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.completeEssentialsNote,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 32),

                        // National ID
                        TextFormField(
                          controller: _nationalIdController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.nationalId,
                            prefixIcon: const Icon(Icons.badge_outlined),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) => ValidationUtils.validateNationalId(
                            value,
                            requiredMessage: AppLocalizations.of(context)!.required,
                            invalidMessage: AppLocalizations.of(context)!.invalidId,
                          ),
                        ).animate().fadeIn(delay: 400.ms).slideX(),
                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.password,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) => ValidationUtils.validatePassword(
                            value,
                            requiredMessage: AppLocalizations.of(context)!.required,
                            tooShortMessage: AppLocalizations.of(context)!.tooShort,
                            weakMessage: 'Password must contain uppercase, lowercase, and number',
                          ),
                        ).animate().fadeIn(delay: 450.ms).slideX(),
                        const SizedBox(height: 16),

                        // Confirm Password
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.confirmPassword,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                              },
                            ),
                          ),
                          obscureText: _obscureConfirmPassword,
                          validator: (value) => ValidationUtils.validatePasswordMatch(
                            value,
                            _passwordController.text,
                            requiredMessage: AppLocalizations.of(context)!.required,
                            mismatchMessage: AppLocalizations.of(context)!.passwordMismatch,
                          ),
                        ).animate().fadeIn(delay: 500.ms).slideX(),
                        const SizedBox(height: 16),

                        // Full Name
                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.fullName,
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                            return null;
                          },
                        ).animate().fadeIn(delay: 550.ms).slideX(),
                        const SizedBox(height: 16),

                        // Date of Birth (Optional)
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dobController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.dobOptional,
                                prefixIcon: const Icon(Icons.calendar_today_outlined),
                                hintText: AppLocalizations.of(context)!.dobHint,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 600.ms).slideX(),
                        const SizedBox(height: 16),

                        // Phone Number (Optional)
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.phoneNumberOptional,
                            prefixIcon: const Icon(Icons.phone_outlined),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) => ValidationUtils.validatePhone(
                            value,
                            invalidMessage: 'Invalid phone number format',
                          ),
                        ).animate().fadeIn(delay: 650.ms).slideX(),
                        const SizedBox(height: 16),

                        // Email (Optional)
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.emailOptional,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => ValidationUtils.validateEmail(
                            value,
                            requiredMessage: '',
                            invalidMessage: 'Invalid email format',
                          ),
                        ).animate().fadeIn(delay: 700.ms).slideX(),
                        const SizedBox(height: 32),

                        // Register Button
                        ElevatedButton(
                          onPressed: signUpState.isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: signUpState.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(AppLocalizations.of(context)!.register.toUpperCase()),
                        ).animate().fadeIn(delay: 750.ms).scale(),
                        const SizedBox(height: 16),

                        // Info text
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: theme.primaryColor,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.postRegistrationNote,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 800.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
