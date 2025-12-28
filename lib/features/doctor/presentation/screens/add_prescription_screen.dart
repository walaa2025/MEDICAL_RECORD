import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:midical_record/features/doctor/data/models/doctor_models.dart';
import 'package:midical_record/features/doctor/presentation/providers/doctor_providers.dart';

class AddPrescriptionScreen extends ConsumerStatefulWidget {
  final int patientId;
  final String patientName;

  const AddPrescriptionScreen({super.key, required this.patientId, required this.patientName});

  @override
  ConsumerState<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends ConsumerState<AddPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  final List<AddPrescriptionItemModel> _items = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (context) => _AddItemDialog(
        onAdd: (item) {
          setState(() {
            _items.add(item);
          });
        },
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.atLeastOneMedication)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await ref.read(authTokenProvider.future);
      if (token != null) {
        final prescription = AddPrescriptionModel(
          patientId: widget.patientId,
          diagnosis: _diagnosisController.text,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          items: _items,
        );

        await ref.read(createPrescriptionProvider.notifier).createPrescription(token, prescription);
        
        final state = ref.read(createPrescriptionProvider);
        state.when(
          data: (result) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.prescriptionCreatedSuccessfully)),
              );
              context.pop();
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
        title: Text(AppLocalizations.of(context)!.newPrescription),
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
                  prefixIcon: const Icon(Icons.local_hospital),
                ),
                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.diagnosisRequired : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.notes,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.note),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.medicationsTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: _addItem,
                    icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_items.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(child: Text(AppLocalizations.of(context)!.noMedicationsAdded)),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.medication),
                        title: Text(item.medicationName),
                        subtitle: Text('${item.dosage ?? ""} - ${item.frequency ?? ""}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeItem(index),
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(AppLocalizations.of(context)!.createPrescription, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddItemDialog extends StatefulWidget {
  final Function(AddPrescriptionItemModel) onAdd;

  const _AddItemDialog({required this.onAdd});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _unitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.addMedication),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               TextFormField(
                 controller: _nameController,
                 decoration: InputDecoration(labelText: '${AppLocalizations.of(context)!.medicationName} *'),
                 validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.required : null,
               ),
               TextFormField(
                 controller: _dosageController,
                 decoration: InputDecoration(labelText: AppLocalizations.of(context)!.dosageLabel),
               ),
               TextFormField(
                 controller: _frequencyController,
                 decoration: InputDecoration(labelText: AppLocalizations.of(context)!.frequencyLabel),
               ),
               TextFormField(
                 controller: _durationController,
                 decoration: InputDecoration(labelText: AppLocalizations.of(context)!.durationLabel),
               ),
               TextFormField(
                 controller: _instructionsController,
                 decoration: InputDecoration(labelText: AppLocalizations.of(context)!.instructionsLabel),
               ),
               TextFormField(
                 controller: _unitController,
                 decoration: InputDecoration(labelText: AppLocalizations.of(context)!.unitLabel),
               ),
             ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel)),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAdd(AddPrescriptionItemModel(
                medicationName: _nameController.text,
                dosage: _dosageController.text,
                frequency: _frequencyController.text,
                duration: _durationController.text,
                instructions: _instructionsController.text,
                unit: _unitController.text,
              ));
              Navigator.pop(context);
            }
          },
          child: Text(AppLocalizations.of(context)!.add),
        ),
      ],
    );
  }
}
