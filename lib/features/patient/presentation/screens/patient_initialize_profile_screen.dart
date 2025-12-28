import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/core/constants/app_enums.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/patient/data/models/patient_models.dart';
import 'package:midical_record/features/patient/presentation/providers/patient_providers.dart';
import 'package:intl/intl.dart';
import 'package:midical_record/l10n/app_localizations.dart';

class PatientInitializeProfileScreen extends ConsumerStatefulWidget {
  const PatientInitializeProfileScreen({super.key});

  @override
  ConsumerState<PatientInitializeProfileScreen> createState() => _PatientInitializeProfileScreenState();
}

class _PatientInitializeProfileScreenState extends ConsumerState<PatientInitializeProfileScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  // Personal Info
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  DateTime? _dateOfBirth;
  Gender _gender = Gender.male;
  BloodType _bloodType = BloodType.aPositive;

  // Lists
  final List<AllergyModel> _allergies = [];
  final List<ChronicDiseaseModel> _chronicDiseases = [];
  final List<SurgeryModel> _surgeries = [];
  final List<CurrentMedicationModel> _medications = [];
  
  // Emergency
  late TextEditingController _emergencyContactController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _emergencyContactController = TextEditingController();
    _emergencyPhoneController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(duration: 400.ms, curve: Curves.easeInOut);
    } else {
      _submit();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: 400.ms, curve: Curves.easeInOut);
    }
  }

  void _submit() async {
    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectBirthDateError)),
      );
      return;
    }

    final token = await ref.read(authTokenProvider.future);
    if (token == null) return;

    final profile = PatientInitializationModel(
      fullName: _nameController.text,
      dateOfBirth: _dateOfBirth!,
      gender: _gender.value,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      address: _addressController.text,
      bloodType: _bloodType.value,
      weight: double.tryParse(_weightController.text),
      height: double.tryParse(_heightController.text),
      emergencyContact: _emergencyContactController.text,
      emergencyPhone: _emergencyPhoneController.text,
      allergies: _allergies,
      chronicDiseases: _chronicDiseases,
      surgeries: _surgeries,
      currentMedications: _medications,
      notes: _notesController.text,
    );

    try {
      showDialog(context: context, barrierDismissible: false, builder: (c) => const Center(child: CircularProgressIndicator()));
      await ref.read(patientProfileProvider.notifier).initializeProfile(token, profile);
      if (mounted) {
        Navigator.pop(context); // Close loading
        context.go('/patient/dashboard');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error(e.toString())), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(theme),
              _buildProgressBar(theme),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (v) => setState(() => _currentPage = v),
                  children: [
                    _buildPersonalInfoStep(theme),
                    _buildMedicalHistoryStep(theme),
                    _buildMedsAndAllergiesStep(theme),
                    _buildEmergencyStep(theme),
                  ],
                ),
              ),
              _buildBottomNav(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    String title = "";
    switch (_currentPage) {
      case 0: title = l10n.basicInfo; break;
      case 1: title = l10n.medicalHistory; break;
      case 2: title = l10n.medsAndAllergies; break;
      case 3: title = l10n.emergency; break;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                l10n.stepCounter(_currentPage + 1, _totalPages),
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: List.generate(_totalPages, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index == _totalPages - 1 ? 0 : 8),
              decoration: BoxDecoration(
                color: index <= _currentPage ? theme.primaryColor : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPersonalInfoStep(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildInput(
            controller: _nameController,
            label: l10n.fullName,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _dateOfBirth = picked);
            },
            child: _buildInputContainer(
              label: l10n.dateOfBirth,
              icon: Icons.calendar_today_outlined,
              child: Text(
                _dateOfBirth == null ? l10n.selectDate : DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
                style: TextStyle(color: _dateOfBirth == null ? Colors.grey : Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDropdown<Gender>(
                  label: l10n.gender,
                  value: _gender,
                  items: Gender.values.map((g) => DropdownMenuItem(value: g, child: Text(g.getLocalizedName(l10n)))).toList(),
                  onChanged: (v) => setState(() => _gender = v!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown<BloodType>(
                  label: l10n.bloodType,
                  value: _bloodType,
                  items: BloodType.values.map((b) => DropdownMenuItem(value: b, child: Text(b.displayName))).toList(),
                  onChanged: (v) => setState(() => _bloodType = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInput(
                  controller: _weightController,
                  label: l10n.weight,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInput(
                  controller: _heightController,
                  label: l10n.height,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
    );
  }

  Widget _buildMedicalHistoryStep(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListSection(
            context: context,
            title: l10n.chronicDiseases,
            items: _chronicDiseases.map((d) => _ListItem(title: d.diseaseName, subtitle: d.description)).toList(),
            onAdd: _addChronicDisease,
            icon: Icons.medical_information_outlined,
          ),
          const SizedBox(height: 32),
          _buildListSection(
            context: context,
            title: l10n.surgeries,
            items: _surgeries.map((s) => _ListItem(title: s.surgeryName, subtitle: s.hospital)).toList(),
            onAdd: _addSurgery,
            icon: Icons.personal_injury_outlined,
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
    );
  }

  Widget _buildMedsAndAllergiesStep(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListSection(
            context: context,
            title: l10n.allergies,
            items: _allergies.map((a) => _ListItem(title: a.allergenName, subtitle: a.reaction)).toList(),
            onAdd: _addAllergy,
            icon: Icons.warning_amber_rounded,
          ),
          const SizedBox(height: 32),
          _buildListSection(
            context: context,
            title: l10n.currentMedications,
            items: _medications.map((m) => _ListItem(title: m.medicationName, subtitle: m.dosage)).toList(),
            onAdd: _addMedication,
            icon: Icons.medication_outlined,
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
    );
  }

  Widget _buildEmergencyStep(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildInput(
            controller: _emergencyContactController,
            label: l10n.emergencyContact,
            icon: Icons.contact_phone_outlined,
          ),
          const SizedBox(height: 20),
          _buildInput(
            controller: _emergencyPhoneController,
            label: l10n.emergencyPhone,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          _buildInput(
            controller: _notesController,
            label: l10n.additionalNotes,
            maxLines: 4,
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade400) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildInputContainer({required String label, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: Colors.grey.shade400),
              const SizedBox(width: 12),
              child,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          labelStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildListSection({
    required BuildContext context,
    required String title,
    required List<_ListItem> items,
    required VoidCallback onAdd,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.grey.shade700),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
            ),
            child: Center(child: Text(AppLocalizations.of(context)!.noDataAdded, style: const TextStyle(color: Colors.grey))),
          )
        else
          ...items.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (item.subtitle != null) Text(item.subtitle!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          )),
      ],
    );
  }

  Widget _buildBottomNav(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(l10n.previous),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(_currentPage == _totalPages - 1 ? l10n.submit : l10n.next),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog implementations (minimal change to logic, just better decoration)
  void _addChronicDisease() async {
    final name = TextEditingController();
    final desc = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    await _showCustomDialog(
      title: l10n.addChronicDisease,
      children: [
        _buildDialogInput(controller: name, label: l10n.diseaseName),
        const SizedBox(height: 16),
        _buildDialogInput(controller: desc, label: l10n.description),
      ],
      onConfirm: () {
        if (name.text.isNotEmpty) {
          setState(() => _chronicDiseases.add(ChronicDiseaseModel(diseaseName: name.text, description: desc.text, diagnosisDate: DateTime.now())));
        }
      },
    );
  }

  void _addSurgery() async {
    final name = TextEditingController();
    final hospital = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    await _showCustomDialog(
      title: l10n.addSurgery,
      children: [
        _buildDialogInput(controller: name, label: l10n.surgeryName),
        const SizedBox(height: 16),
        _buildDialogInput(controller: hospital, label: l10n.hospital),
      ],
      onConfirm: () {
        if (name.text.isNotEmpty) {
          setState(() => _surgeries.add(SurgeryModel(surgeryName: name.text, hospital: hospital.text, surgeryDate: DateTime.now())));
        }
      },
    );
  }

  void _addAllergy() async {
    final name = TextEditingController();
    final reaction = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    await _showCustomDialog(
      title: l10n.addAllergy,
      children: [
        _buildDialogInput(controller: name, label: l10n.allergen),
        const SizedBox(height: 16),
        _buildDialogInput(controller: reaction, label: l10n.reaction),
      ],
      onConfirm: () {
        if (name.text.isNotEmpty) {
          setState(() => _allergies.add(AllergyModel(allergenName: name.text, reaction: reaction.text, severity: 'Normal')));
        }
      },
    );
  }

  void _addMedication() async {
    final name = TextEditingController();
    final dosage = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    await _showCustomDialog(
      title: l10n.addMedication,
      children: [
        _buildDialogInput(controller: name, label: l10n.medicationName),
        const SizedBox(height: 16),
        _buildDialogInput(controller: dosage, label: l10n.dosage),
      ],
      onConfirm: () {
        if (name.text.isNotEmpty) {
          setState(() => _medications.add(CurrentMedicationModel(medicationName: name.text, dosage: dosage.text)));
        }
      },
    );
  }

  Future<void> _showCustomDialog({required String title, required List<Widget> children, required VoidCallback onConfirm}) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(mainAxisSize: MainAxisSize.min, children: children),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel)),
          ElevatedButton(onPressed: () { onConfirm(); Navigator.pop(context); }, child: Text(AppLocalizations.of(context)!.add)),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildDialogInput({required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class _ListItem {
  final String title;
  final String? subtitle;
  _ListItem({required this.title, this.subtitle});
}

