import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:midical_record/features/doctor/data/models/doctor_models.dart';
import 'package:midical_record/features/doctor/presentation/providers/doctor_providers.dart';

class AddMedicalRecordScreen extends ConsumerStatefulWidget {
  final int patientId;
  final String patientName;

  const AddMedicalRecordScreen({super.key, required this.patientId, required this.patientName});

  @override
  ConsumerState<AddMedicalRecordScreen> createState() => _AddMedicalRecordScreenState();
}

class _AddMedicalRecordScreenState extends ConsumerState<AddMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _diagnosisController.dispose();
    _symptomsController.dispose();
    _treatmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final token = await ref.read(authTokenProvider.future);
      if (token != null) {
        final record = AddMedicalRecordModel(
          patientId: widget.patientId,
          diagnosis: _diagnosisController.text,
          symptoms: _symptomsController.text.isNotEmpty ? _symptomsController.text : null,
          treatment: _treatmentController.text.isNotEmpty ? _treatmentController.text : null,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          recordDate: DateTime.now().toIso8601String(),
        );

        await ref.read(addMedicalRecordProvider.notifier).addRecord(token, record);
        
        // Check for error in state
        final state = ref.read(addMedicalRecordProvider);
        state.when(
          data: (result) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.recordAddedSuccessfully)),
              );
              context.pop(); // Return to previous screen
            }
          },
          loading: () {},
          error: (e, _) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.error(e.toString())), backgroundColor: Colors.red),
              );
            }
          }
        );
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addMedicalRecord),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.patientLabel(widget.patientName),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _diagnosisController,
                decoration: InputDecoration(
                  labelText: '${AppLocalizations.of(context)!.diagnosis} *',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.monitor_heart),
                ),
                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.diagnosisRequired : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _symptomsController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.symptomsLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.sick),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _treatmentController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.treatmentPlan,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.healing),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.additionalNotes,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(AppLocalizations.of(context)!.saveRecord, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
