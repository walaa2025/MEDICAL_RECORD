import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/patient/data/models/patient_models.dart';
import 'package:midical_record/features/patient/presentation/providers/patient_providers.dart';
import 'package:midical_record/core/constants/app_enums.dart'; // For Gender/BloodType
import 'package:midical_record/l10n/app_localizations.dart';

class PatientEditProfileScreen extends ConsumerStatefulWidget {
  final PatientProfileModel profile;

  const PatientEditProfileScreen({super.key, required this.profile});

  @override
  ConsumerState<PatientEditProfileScreen> createState() => _PatientEditProfileScreenState();
}

class _PatientEditProfileScreenState extends ConsumerState<PatientEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _emergencyPhoneController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    _phoneController = TextEditingController(text: widget.profile.phoneNumber);
    _heightController = TextEditingController(text: widget.profile.height?.toString() ?? '');
    _weightController = TextEditingController(text: widget.profile.weight?.toString() ?? '');
    _emergencyContactController = TextEditingController(text: widget.profile.emergencyContact);
    _emergencyPhoneController = TextEditingController(text: widget.profile.emergencyPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final token = await ref.read(authTokenProvider.future);
      if (token != null) {
        final updateModel = PatientInitializationModel(
          fullName: _nameController.text,
          dateOfBirth: widget.profile.dateOfBirth ?? DateTime.now(),
          gender: widget.profile.gender.value,
          bloodType: widget.profile.bloodType?.value,
          phoneNumber: _phoneController.text,
          height: double.tryParse(_heightController.text),
          weight: double.tryParse(_weightController.text),
          emergencyContact: _emergencyContactController.text,
          emergencyPhone: _emergencyPhoneController.text,
          chronicDiseases: [], 
          allergies: [], 
          currentMedications: [], 
          surgeries: [], 
        );

        await ref.read(patientProfileProvider.notifier).updateProfile(token, updateModel);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.profileUpdatedSuccess),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error(e.toString())), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(l10n.basicInfo),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: l10n.fullName,
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? l10n.required : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: l10n.phoneNumber,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle(l10n.biometrics),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _heightController,
                      label: l10n.height,
                      icon: Icons.height,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _weightController,
                      label: l10n.weight,
                      icon: Icons.monitor_weight_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(l10n.emergencyContact),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emergencyContactController,
                label: l10n.fullName,
                icon: Icons.emergency_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emergencyPhoneController,
                label: l10n.emergencyPhone,
                icon: Icons.emergency_share_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: theme.primaryColor.withOpacity(0.4),
                  ),
                  child: _isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(l10n.saveChanges, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade400),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
