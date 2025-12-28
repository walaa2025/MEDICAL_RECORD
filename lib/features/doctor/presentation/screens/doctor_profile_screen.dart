import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/doctor/presentation/providers/doctor_providers.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:midical_record/features/doctor/data/models/doctor_models.dart';

class DoctorProfileScreen extends ConsumerStatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  ConsumerState<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends ConsumerState<DoctorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _licenseController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isInitialized = false;
  bool _isEditMode = false; // Edit mode toggle
  
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = ref.read(authTokenProvider).value;
      if (token != null) {
        ref.read(doctorProfileProvider.notifier).loadProfile(token);
      }
    });
  }

  void _initializeControllers(DoctorProfileModel profile) {
    if (!_isInitialized) {
      _nameController.text = profile.fullName;
      _specializationController.text = profile.specialization ?? '';
      _licenseController.text = profile.licenseNumber ?? '';
      _hospitalController.text = profile.hospital ?? '';
      _emailController.text = profile.email ?? '';
      _phoneController.text = profile.phoneNumber ?? '';
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _licenseController.dispose();
    _hospitalController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final token = ref.read(authTokenProvider).value;
      if (token == null) return;

      final updatedProfile = DoctorProfileModel(
        fullName: _nameController.text,
        specialization: _specializationController.text,
        licenseNumber: _licenseController.text,
        hospital: _hospitalController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
      );

      await ref.read(doctorProfileProvider.notifier).updateProfile(token, updatedProfile);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdatedSuccess)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(doctorProfileProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.doctorProfile),
        actions: [
          profileState.when(
            data: (profile) => profile != null 
                ? IconButton(
                    icon: Icon(_isEditMode ? Icons.close : Icons.edit),
                    onPressed: () {
                      setState(() {
                        if (_isEditMode) {
                          // Cancel edit - reload profile
                          _isInitialized = false;
                          _initializeControllers(profile);
                        }
                        _isEditMode = !_isEditMode;
                      });
                    },
                  )
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
      body: profileState.when(
        data: (profile) {
          if (profile == null) return Center(child: Text(AppLocalizations.of(context)!.profileNotFound));
          _initializeControllers(profile);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.primaryColor,
                    child: Text(
                      _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'D',
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Editable Header
                  TextFormField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    readOnly: !_isEditMode,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: _isEditMode ? const UnderlineInputBorder() : InputBorder.none,
                      hintText: 'Full Name',
                    ),
                    validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.required : null,
                  ),
                  TextFormField(
                    controller: _specializationController,
                    textAlign: TextAlign.center,
                    readOnly: !_isEditMode,
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                    decoration: InputDecoration(
                      border: _isEditMode ? const UnderlineInputBorder() : InputBorder.none,
                      hintText: 'Specialization',
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildEditableTile(
                            context,
                            controller: _licenseController,
                            label: AppLocalizations.of(context)!.licenseNumberLabel,
                            icon: Icons.medication,
                          ),
                          const Divider(),
                          _buildEditableTile(
                            context,
                            controller: _hospitalController,
                            label: AppLocalizations.of(context)!.hospitalLabel,
                            icon: Icons.local_hospital,
                          ),
                          const Divider(),
                          _buildEditableTile(
                            context,
                            controller: _emailController,
                            label: AppLocalizations.of(context)!.emailLabel,
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const Divider(),
                          _buildEditableTile(
                            context,
                            controller: _phoneController,
                            label: AppLocalizations.of(context)!.phoneLabel,
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  if (_isEditMode)
                    ElevatedButton(
                      onPressed: profileState.isLoading ? null : () async {
                        await _saveProfile();
                        setState(() => _isEditMode = false);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: profileState.isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(AppLocalizations.of(context)!.saveChanges),
                    ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(AppLocalizations.of(context)!.error(e.toString()))),
      ),
    );
  }

  Widget _buildEditableTile(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: !_isEditMode,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: _isEditMode ? const UnderlineInputBorder() : InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}
