
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:midical_record/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:midical_record/core/utils/validation_utils.dart';

/// Pharmacist Sign-Up Screen
/// Registration for pharmacists (requires admin approval)
class PharmacistSignUpScreen extends ConsumerStatefulWidget {
  const PharmacistSignUpScreen({super.key});

  @override
  ConsumerState<PharmacistSignUpScreen> createState() => _PharmacistSignUpScreenState();
}

class _PharmacistSignUpScreenState extends ConsumerState<PharmacistSignUpScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final _nationalIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _licenseDocumentUrlController = TextEditingController();
  final _pharmacyNameController = TextEditingController();

  // Track password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  PlatformFile? _licenseFile;

  @override
  void dispose() {
    _nationalIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _licenseNumberController.dispose();
    _licenseDocumentUrlController.dispose();
    _pharmacyNameController.dispose();
    super.dispose();
  }

  Future<void> _pickLicense() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _licenseFile = result.files.first;
        _licenseDocumentUrlController.text = _licenseFile!.name;
      });
    }
  }

  /// Submit registration form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final dataSource = ref.read(authRemoteDataSourceProvider);
        final response = await dataSource.registerPharmacist(
          nationalId: _nationalIdController.text.trim(),
          password: _passwordController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim(),
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim().isEmpty ? '' : _emailController.text.trim(), // Optional
          phoneNumber: _phoneNumberController.text.trim().isEmpty ? '' : _phoneNumberController.text.trim(), // Optional
          licenseNumber: _licenseNumberController.text.trim(),
          licenseDocumentUrl: _licenseDocumentUrlController.text.trim().isEmpty ? '' : _licenseDocumentUrlController.text.trim(), // Optional
          pharmacyName: _pharmacyNameController.text.trim().isEmpty ? '' : _pharmacyNameController.text.trim(), // Optional
        );

        if (mounted) {
          setState(() => _isLoading = false);

          if (response.success) {
            // Show success dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 32),
                    const SizedBox(width: 12),
                    Expanded(child: Text(AppLocalizations.of(context)!.registrationSubmitted)),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(response.message),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.pendingApprovalNote,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
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
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pharmacistRegistration),
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
                          Icons.local_pharmacy,
                          size: 64,
                          color: theme.primaryColor,
                        ).animate().scale(duration: 600.ms).fadeIn(),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.createAccount, // Or specific title
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.pendingApprovalNote, // Repurposing or add specific
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                            if (value.length < 10) return AppLocalizations.of(context)!.invalidId;
                            return null;
                          },
                        ).animate().fadeIn(delay: 400.ms).slideX(),
                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
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
                          validator: (value) {
                            if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                            if (value.length < 6) return AppLocalizations.of(context)!.tooShort;
                            return null;
                          },
                        ).animate().fadeIn(delay: 450.ms).slideX(),
                        const SizedBox(height: 16),

                        // Confirm Password
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
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
                          validator: (value) {
                            if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                            if (value != _passwordController.text) return AppLocalizations.of(context)!.passwordMismatch;
                            return null;
                          },
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

                        // Email
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.emailOptional,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value != null && value.isNotEmpty && !value.contains('@')) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                        ).animate().fadeIn(delay: 600.ms).slideX(),
                        const SizedBox(height: 16),

                        // Phone Number
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.phoneNumberOptional,
                            prefixIcon: const Icon(Icons.phone_outlined),
                          ),
                          keyboardType: TextInputType.phone,
                        ).animate().fadeIn(delay: 650.ms).slideX(),
                        
                        const SizedBox(height: 24),

                        // Professional Information Section
                        _buildSectionHeader(AppLocalizations.of(context)!.professionalInformation, Icons.work_outline),
                        const SizedBox(height: 16),

                        // License Number
                        TextFormField(
                          controller: _licenseNumberController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.licenseNumber,
                            prefixIcon: const Icon(Icons.verified_outlined),
                          ),
                          validator: (value) => ValidationUtils.validateLicenseNumber(
                            value,
                            requiredMessage: AppLocalizations.of(context)!.required,
                          ),
                        ).animate().fadeIn(delay: 700.ms).slideX(),
                        const SizedBox(height: 16),

                        // License Document URL (Required)
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _licenseDocumentUrlController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.licenseDocumentUrl,
                                  prefixIcon: const Icon(Icons.file_present),
                                ),
                                readOnly: true,
                                onTap: _pickLicense,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: _pickLicense,
                              icon: const Icon(Icons.browse_gallery),
                              label: Text(AppLocalizations.of(context)!.add),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Pharmacy Name
                        TextFormField(
                          controller: _pharmacyNameController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.pharmacyName,
                            prefixIcon: const Icon(Icons.store_outlined),
                          ),
                        ).animate().fadeIn(delay: 800.ms).slideX(),
                        const SizedBox(height: 32),

                        // Register Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(AppLocalizations.of(context)!.register.toUpperCase()),
                        ).animate().fadeIn(delay: 850.ms).scale(),
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }
}
