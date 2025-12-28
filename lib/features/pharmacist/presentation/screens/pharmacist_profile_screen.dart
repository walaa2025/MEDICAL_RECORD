import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/pharmacist/presentation/providers/pharmacist_providers.dart';
import 'package:midical_record/features/pharmacist/data/models/pharmacist_models.dart';
import 'package:midical_record/core/constants/app_enums.dart';
import 'package:midical_record/l10n/app_localizations.dart';

class PharmacistProfileScreen extends ConsumerStatefulWidget {
  const PharmacistProfileScreen({super.key});

  @override
  ConsumerState<PharmacistProfileScreen> createState() => _PharmacistProfileScreenState();
}

class _PharmacistProfileScreenState extends ConsumerState<PharmacistProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _pharmacyController = TextEditingController();
  final _licenseController = TextEditingController();
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
        ref.read(pharmacistProfileProvider.notifier).loadProfile(token);
      }
    });
  }

  void _initializeControllers(PharmacistProfileModel profile) {
    if (!_isInitialized) {
      _nameController.text = profile.fullName;
      _pharmacyController.text = profile.pharmacyName;
      _licenseController.text = profile.licenseNumber;
      _emailController.text = profile.email;
      _phoneController.text = profile.phoneNumber ?? '';
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pharmacyController.dispose();
    _licenseController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final token = ref.read(authTokenProvider).value;
      if (token == null) return;

      final updatedProfile = PharmacistProfileModel(
        nationalId: ref.read(pharmacistProfileProvider).value?.nationalId ?? '', // Keep existing
        fullName: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        licenseNumber: _licenseController.text,
        pharmacyName: _pharmacyController.text,
        status: ref.read(pharmacistProfileProvider).value?.status ?? UserStatus.pending,
      );

      await ref.read(pharmacistProfileProvider.notifier).updateProfile(token, updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdatedSuccess)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(pharmacistProfileProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pharmacistProfile),
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
                    backgroundColor: Colors.green,
                    child: Text(
                      _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'P',
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
                    controller: _pharmacyController,
                    textAlign: TextAlign.center,
                    readOnly: !_isEditMode,
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                    decoration: InputDecoration(
                      border: _isEditMode ? const UnderlineInputBorder() : InputBorder.none,
                      hintText: 'Pharmacy Name',
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
                            icon: Icons.badge,
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
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: Text(AppLocalizations.of(context)!.statusLabel),
                            subtitle: Text(profile.status.name.toUpperCase()),
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
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
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
