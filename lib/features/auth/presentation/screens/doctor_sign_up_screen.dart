
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/auth/domain/entities/doctor_entity.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:midical_record/core/utils/validation_utils.dart';

class DoctorSignUpScreen extends ConsumerStatefulWidget {
  const DoctorSignUpScreen({super.key});

  @override
  ConsumerState<DoctorSignUpScreen> createState() => _DoctorSignUpScreenState();
}

class _DoctorSignUpScreenState extends ConsumerState<DoctorSignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _licenseUrlController = TextEditingController(); // Optional link
  final TextEditingController _hospitalController = TextEditingController();

  PlatformFile? _licenseFile;

  // Dropdown Values
  String? _selectedSpecialization;
  final List<String> _specializations = [
    'General Practitioner',
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'Neurologist',
    'Orthopedist',
    'Psychiatrist',
    'Surgeon',
    'Other'
  ];

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nationalIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _licenseUrlController.dispose();
    _hospitalController.dispose();
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
        _licenseUrlController.text = _licenseFile!.name;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final doctor = DoctorEntity(
        nationalId: _nationalIdController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        name: _nameController.text,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        licenseNumber: _licenseController.text,
        licenseDocumentUrl: _licenseUrlController.text, // Required
        specialization: _selectedSpecialization,
        hospital: _hospitalController.text.isNotEmpty ? _hospitalController.text : null,
      );

      ref.read(signUpDoctorControllerProvider.notifier).register(doctor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signUpState = ref.watch(signUpDoctorControllerProvider);

    ref.listen<AsyncValue<void>>(signUpDoctorControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString()), backgroundColor: theme.colorScheme.error),
        );
      }
      if (previous?.isLoading == true && !next.isLoading && !next.hasError) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.registrationSubmitted),
            content: Text(AppLocalizations.of(context)!.pendingApprovalNote),
            actions: [
              TextButton(
                onPressed: () {
                   context.go('/login');
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          ),
        );
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.doctorRegistration),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              Colors.green.shade50, // Slight green tint for doctors
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // HEADER
                  Icon(Icons.medical_services_rounded, size: 48, color: theme.primaryColor)
                      .animate().fadeIn().moveY(begin: -20, end: 0, duration: 600.ms),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.joinAsSpecialist,
                    style: theme.textTheme.headlineMedium?.copyWith(color: theme.primaryColor),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms),
                  
                  const SizedBox(height: 32),

                  Card(
                    elevation: 4,
                    shadowColor: theme.shadowColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          // 1. National ID (Required)
                          _buildTextField(
                            context,
                            controller: _nationalIdController, 
                            label: AppLocalizations.of(context)!.nationalId, 
                            icon: Icons.badge,
                            keyboardType: TextInputType.number,
                            validator: (v) => ValidationUtils.validateNationalId(
                              v,
                              requiredMessage: AppLocalizations.of(context)!.required,
                              invalidMessage: AppLocalizations.of(context)!.invalidId,
                            )
                          ),
                          const SizedBox(height: 16),

                          // 2. Password (Required)
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.password,
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (v) => ValidationUtils.validatePassword(
                              v,
                              requiredMessage: AppLocalizations.of(context)!.required,
                              tooShortMessage: AppLocalizations.of(context)!.tooShort,
                              weakMessage: 'Password must contain uppercase, lowercase, and number',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 3. Confirm Password (Required)
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.confirmPassword,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                              ),
                            ),
                            validator: (v) => ValidationUtils.validatePasswordMatch(
                              v,
                              _passwordController.text,
                              requiredMessage: AppLocalizations.of(context)!.required,
                              mismatchMessage: AppLocalizations.of(context)!.passwordMismatch,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 4. Name (Required)
                          _buildTextField(
                            context,
                            controller: _nameController, 
                            label: AppLocalizations.of(context)!.fullName, 
                            icon: Icons.person,
                            validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.required : null
                          ),
                          const SizedBox(height: 16),

                          // 5. Email (Optional)
                          _buildTextField(
                            context,
                            controller: _emailController, 
                            label: AppLocalizations.of(context)!.emailOptional, 
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),

                          // 6. Phone Number (Optional)
                           _buildTextField(
                            context,
                            controller: _phoneController, 
                            label: AppLocalizations.of(context)!.phoneNumberOptional, 
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),

                          // 7. License Number (Required)
                          _buildTextField(
                            context,
                            controller: _licenseController, 
                            label: AppLocalizations.of(context)!.licenseNumber, 
                            icon: Icons.verified_user,
                            validator: (v) => ValidationUtils.validateLicenseNumber(
                              v,
                              requiredMessage: AppLocalizations.of(context)!.required,
                            )
                          ),
                          const SizedBox(height: 16),

                          // 8. License Document (Required)
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  context,
                                  controller: _licenseUrlController, 
                                  label: AppLocalizations.of(context)!.licenseDocumentUrl, 
                                  icon: Icons.file_present,
                                  readOnly: true,
                                  validator: (v) => v == null || v.isEmpty ? AppLocalizations.of(context)!.required : null,
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

                          // 9. Specialization (Optional)
                          _buildDropdown(
                            context,
                            label: AppLocalizations.of(context)!.specialization,
                            value: _selectedSpecialization,
                            items: _specializations,
                            icon: Icons.category,
                            onChanged: (v) => setState(() => _selectedSpecialization = v),
                          ),
                          const SizedBox(height: 16),

                          // 10. Hospital (Optional)
                          _buildTextField(
                            context,
                            controller: _hospitalController, 
                            label: AppLocalizations.of(context)!.hospital, 
                            icon: Icons.local_hospital,
                          ),

                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

                  const SizedBox(height: 32),

                  // SUBMIT BUTTON
                  ElevatedButton(
                    onPressed: signUpState.isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: signUpState.isLoading
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(AppLocalizations.of(context)!.register.toUpperCase()),
                  ).animate().fadeIn(delay: 500.ms).scale(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      onTap: readOnly ? _pickLicense : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
