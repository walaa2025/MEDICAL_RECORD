import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/doctor/data/models/doctor_models.dart';
import 'package:midical_record/features/doctor/presentation/providers/doctor_providers.dart';

/// Create Prescription Screen
/// Form for doctors to create prescriptions for patients
class CreatePrescriptionScreen extends ConsumerStatefulWidget {
  final String patientIdentifier;

  const CreatePrescriptionScreen({super.key, required this.patientIdentifier});

  @override
  ConsumerState<CreatePrescriptionScreen> createState() => _CreatePrescriptionScreenState();
}

class _CreatePrescriptionScreenState extends ConsumerState<CreatePrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final List<_MedicationEntry> _medications = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _addMedication(); // Start with one medication
  }

  @override
  void dispose() {
    _notesController.dispose();
    for (var med in _medications) {
      med.dispose();
    }
    super.dispose();
  }

  void _addMedication() {
    setState(() {
      _medications.add(_MedicationEntry());
    });
  }

  void _removeMedication(int index) {
    setState(() {
      _medications[index].dispose();
      _medications.removeAt(index);
    });
  }

  Future<void> _submitPrescription() async {
    if (!_formKey.currentState!.validate()) return;
    if (_medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one medication')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final medicationItems = _medications.map((m) => MedicationItemModel(
        medicationName: m.nameController.text.trim(),
        dosage: m.dosageController.text.trim(),
        frequency: m.frequencyController.text.trim(),
        duration: int.tryParse(m.durationController.text.trim()),
      )).toList();

      final prescription = CreatePrescriptionModel(
        patientId: 0, // TODO: Get from patient record
        medications: medicationItems,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      // TODO: Submit with token
      // final token = ref.read(authTokenProvider);
      // await ref.read(createPrescriptionProvider.notifier).createPrescription(token, prescription);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prescription created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Prescription'),
        backgroundColor: Colors.green,
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
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.medication, color: Colors.green.shade700, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Add medications for this prescription',
                                style: TextStyle(
                                  color: Colors.green.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                    const SizedBox(height: 24),

                    // Medications List
                    Text(
                      'Medications',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ..._medications.asMap().entries.map((entry) {
                      final index = entry.key;
                      final med = entry.value;
                      return _buildMedicationCard(med, index, theme);
                    }),

                    // Add Medication Button
                    OutlinedButton.icon(
                      onPressed: _addMedication,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Another Medication'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.green, width: 2),
                        foregroundColor: Colors.green,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 24),

                    // Notes
                    Text(
                      'Prescription Notes (Optional)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        hintText: 'Special instructions, warnings, etc...',
                        prefixIcon: const Icon(Icons.note_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      maxLines: 3,
                    ).animate().fadeIn(delay: 400.ms),
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
                onPressed: _isSubmitting ? null : _submitPrescription,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSubmitting ? 'Creating...' : 'Create Prescription'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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

  Widget _buildMedicationCard(_MedicationEntry med, int index, ThemeData theme) {
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
                  'Medication ${index + 1}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
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

            // Medication Name
            TextFormField(
              controller: med.nameController,
              decoration: InputDecoration(
                labelText: 'Medication Name',
                hintText: 'e.g., Amoxicillin',
                prefixIcon: const Icon(Icons.medication),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            // Dosage & Frequency Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: med.dosageController,
                    decoration: InputDecoration(
                      labelText: 'Dosage',
                      hintText: '500mg',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: med.frequencyController,
                    decoration: InputDecoration(
                      labelText: 'Frequency',
                      hintText: '3x daily',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Duration
            TextFormField(
              controller: med.durationController,
              decoration: InputDecoration(
                labelText: 'Duration (days)',
                hintText: '7',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX();
  }
}

class _MedicationEntry {
  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final frequencyController = TextEditingController();
  final durationController = TextEditingController();

  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    durationController.dispose();
  }
}
