import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:midical_record/features/doctor/data/models/doctor_models.dart';
import 'package:midical_record/features/doctor/presentation/providers/doctor_providers.dart';

/// Add Diagnosis Screen
/// Form for doctors to add medical record/diagnosis for a patient
class AddDiagnosisScreen extends ConsumerStatefulWidget {
  final String patientIdentifier;

  const AddDiagnosisScreen({super.key, required this.patientIdentifier});

  @override
  ConsumerState<AddDiagnosisScreen> createState() => _AddDiagnosisScreenState();
}

class _AddDiagnosisScreenState extends ConsumerState<AddDiagnosisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitDiagnosis() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // TODO: Get patientId from the patient record
      final record = AddMedicalRecordModel(
        patientId: 0, // This should come from patient record
        diagnosis: _diagnosisController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      // TODO: Submit with token
      // final token = ref.read(authTokenProvider);
      // await ref.read(addMedicalRecordProvider.notifier).addRecord(token, record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.recordAddedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.error(e.toString())),
            backgroundColor: Colors.red,
          ),
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
        title: Text(AppLocalizations.of(context)!.addDiagnosis),
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.addDiagnosisInstruction,
                          style: TextStyle(color: Colors.blue.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn().slideY(begin: -0.2, end: 0),
              const SizedBox(height: 24),

              // Diagnosis Field
              Text(
                AppLocalizations.of(context)!.diagnosis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 8),
              TextFormField(
                controller: _diagnosisController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.diagnosisFieldHint,
                  prefixIcon: const Icon(Icons.medical_services),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)!.diagnosisRequired;
                  }
                  return null;
                },
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 24),

              // Notes Field
              Text(
                AppLocalizations.of(context)!.clinicalNotesOptional,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.notesFieldHint,
                  prefixIcon: const Icon(Icons.note_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                maxLines: 6,
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitDiagnosis,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSubmitting ? AppLocalizations.of(context)!.saving : AppLocalizations.of(context)!.saveRecord),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }
}
