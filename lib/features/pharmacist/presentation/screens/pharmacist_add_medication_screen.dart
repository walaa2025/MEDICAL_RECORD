import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/pharmacist/data/datasources/pharmacist_remote_data_source.dart';
import 'package:midical_record/l10n/app_localizations.dart';

/// Add Extra Medication Screen
/// Allows pharmacists to add extra medications when doctor forgot to add
class PharmacistAddMedicationScreen extends ConsumerStatefulWidget {
  const PharmacistAddMedicationScreen({super.key});

  @override
  ConsumerState<PharmacistAddMedicationScreen> createState() => _PharmacistAddMedicationScreenState();
}

class _PharmacistAddMedicationScreenState extends ConsumerState<PharmacistAddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _doctorIdController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final List<_MedicationItem> _medications = [];
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addMedication(); // Start with one medication
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _doctorIdController.dispose();
    _diagnosisController.dispose();
    for (var med in _medications) {
      med.dispose();
    }
    super.dispose();
  }

  void _addMedication() {
    setState(() {
      _medications.add(_MedicationItem());
    });
  }

  void _removeMedication(int index) {
    if (_medications.length > 1) {
      setState(() {
        _medications[index].dispose();
        _medications.removeAt(index);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.addAtLeastOneMedication)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await ref.read(authTokenProvider.future);
      if (token != null) {
        final items = _medications.map((m) => {
          'drugId': int.tryParse(m.drugIdController.text.trim()) ?? 0,
          'quantity': int.tryParse(m.quantityController.text.trim()) ?? 0,
          'dosage': m.dosageController.text.trim(),
          'frequency': m.frequencyController.text.trim(),
          'duration': m.durationController.text.trim(),
          'instructions': m.instructionsController.text.trim().isEmpty 
              ? null 
              : m.instructionsController.text.trim(),
        }).toList();

        final data = {
          'patientId': int.parse(_patientIdController.text.trim()),
          'doctorId': int.parse(_doctorIdController.text.trim()),
          'diagnosis': _diagnosisController.text.trim(),
          'items': items,
        };

        final dataSource = PharmacistRemoteDataSource();
        final response = await dataSource.createExtraMedication(
          token: token,
          data: data,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? AppLocalizations.of(context)!.medicationAddedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addExtraMedication),
        backgroundColor: Colors.deepOrange,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card
                    Card(
                      color: Colors.deepOrange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.add_circle, color: Colors.deepOrange.shade700, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.addExtraMedicationInfo,
                                style: TextStyle(
                                  color: Colors.deepOrange.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                    const SizedBox(height: 24),

                    // Patient ID
                    TextFormField(
                      controller: _patientIdController,
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.patientId} *',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? AppLocalizations.of(context)!.required
                          : null,
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 16),

                    // Doctor ID
                    TextFormField(
                      controller: _doctorIdController,
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.doctorId} *',
                        prefixIcon: const Icon(Icons.medical_services),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? AppLocalizations.of(context)!.required
                          : null,
                    ).animate().fadeIn(delay: 150.ms),
                    const SizedBox(height: 16),

                    // Diagnosis
                    TextFormField(
                      controller: _diagnosisController,
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.diagnosis} *',
                        prefixIcon: const Icon(Icons.monitor_heart),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty
                          ? AppLocalizations.of(context)!.required
                          : null,
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 24),

                    // Medications Section
                    Text(
                      AppLocalizations.of(context)!.medications,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Medication Items
                    ..._medications.asMap().entries.map((entry) {
                      final index = entry.key;
                      final med = entry.value;
                      return _buildMedicationCard(med, index, theme);
                    }),

                    // Add Medication Button
                    OutlinedButton.icon(
                      onPressed: _addMedication,
                      icon: const Icon(Icons.add),
                      label: Text(AppLocalizations.of(context)!.addMedication),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.deepOrange, width: 2),
                        foregroundColor: Colors.deepOrange,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                  ],
                ),
              ),
            ),

            // Submit Button (Fixed at bottom)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? AppLocalizations.of(context)!.saving : AppLocalizations.of(context)!.save),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationCard(_MedicationItem med, int index, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.medication} ${index + 1}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                if (_medications.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeMedication(index),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Drug ID
            TextFormField(
              controller: med.drugIdController,
              decoration: InputDecoration(
                labelText: '${AppLocalizations.of(context)!.drugId} *',
                hintText: '1',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.trim().isEmpty
                  ? AppLocalizations.of(context)!.required
                  : null,
            ),
            const SizedBox(height: 12),

            // Quantity & Dosage Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: med.quantityController,
                    decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context)!.quantity} *',
                      hintText: '10',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? AppLocalizations.of(context)!.required
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: med.dosageController,
                    decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context)!.dosage} *',
                      hintText: '500mg',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? AppLocalizations.of(context)!.required
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Frequency & Duration Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: med.frequencyController,
                    decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context)!.frequency} *',
                      hintText: '3x daily',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? AppLocalizations.of(context)!.required
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: med.durationController,
                    decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context)!.duration} *',
                      hintText: '7 days',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? AppLocalizations.of(context)!.required
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Instructions
            TextFormField(
              controller: med.instructionsController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.instructions,
                hintText: AppLocalizations.of(context)!.takeAfterMeals,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX();
  }
}

class _MedicationItem {
  final drugIdController = TextEditingController();
  final quantityController = TextEditingController();
  final dosageController = TextEditingController();
  final frequencyController = TextEditingController();
  final durationController = TextEditingController();
  final instructionsController = TextEditingController();

  void dispose() {
    drugIdController.dispose();
    quantityController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    durationController.dispose();
    instructionsController.dispose();
  }
}
