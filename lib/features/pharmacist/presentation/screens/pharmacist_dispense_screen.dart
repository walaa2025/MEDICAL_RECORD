import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:midical_record/features/pharmacist/data/models/pharmacist_models.dart';
import 'package:midical_record/features/pharmacist/presentation/providers/pharmacist_providers.dart';

class PharmacistDispenseScreen extends ConsumerStatefulWidget {
  final PrescriptionSearchResultModel prescription;

  const PharmacistDispenseScreen({super.key, required this.prescription});

  @override
  ConsumerState<PharmacistDispenseScreen> createState() => _PharmacistDispenseScreenState();
}

class _PharmacistDispenseScreenState extends ConsumerState<PharmacistDispenseScreen> {
  final Map<int, bool> _selectedItems = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize checkboxes - default to unchecked or based on isDispensed?
    // Usually we dispense what is NOT dispensed yet.
    for (var item in widget.prescription.medications) {
      if (!item.isDispensed) {
        _selectedItems[item.id ?? 0] = false;
      }
    }
  }

  void _checkInteractions() async {
    final medications = widget.prescription.medications.map((m) => m.medicationName).toList();
    if (medications.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.needMedicationsForInteraction)),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final token = await ref.read(authTokenProvider.future);
      if (token != null) {
        await ref.read(drugInteractionsProvider.notifier).checkInteractions(token, medications);
        
        if (mounted) {
          Navigator.pop(context); // Hide loading
          _showInteractionsDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.error(e.toString()))));
      }
    }
  }

  void _showInteractionsDialog() {
    final interactions = ref.read(drugInteractionsProvider).value;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.drugInteractions),
        content: SizedBox(
          width: double.maxFinite,
          child: interactions == null || interactions.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 48),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.noInteractionsFound),
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: interactions.length,
                  itemBuilder: (context, index) {
                    final interaction = interactions[index];
                    return Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${interaction.medication1} + ${interaction.medication2}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(AppLocalizations.of(context)!.severityLabel(interaction.severity), style: const TextStyle(color: Colors.red)),
                            if (interaction.description != null)
                              Text(interaction.description!),
                            if (interaction.recommendation != null)
                              Text(AppLocalizations.of(context)!.recommendationLabel(interaction.recommendation!), style: const TextStyle(fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.close)),
        ],
      ),
    );
  }

  Future<void> _dispense() async {
    final itemsToDispense = _selectedItems.entries.where((e) => e.value).map((e) => DispenseItemModel(
      prescriptionItemId: e.key,
      dispensed: true,
    )).toList();

    if (itemsToDispense.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectItemsToDispense)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await ref.read(authTokenProvider.future);
      if (token != null) {
        final dispenseModel = DispensePrescriptionModel(
          prescriptionId: widget.prescription.prescriptionId,
          items: itemsToDispense,
        );

        await ref.read(dispensePrescriptionProvider.notifier).dispense(token, dispenseModel);
        
        final state = ref.read(dispensePrescriptionProvider);
        state.when(
          data: (result) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.medicationsDispensedSuccess)),
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

  Future<void> _updateStatus(int newStatus) async {
    final l10n = AppLocalizations.of(context)!;
    final notesController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.updateStatus),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.confirmStatusChange),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: l10n.notes,
                hintText: l10n.optionalNotes,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.confirm)),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        final token = await ref.read(authTokenProvider.future);
        if (token != null) {
          await ref.read(prescriptionStatusProvider.notifier).updateStatus(
            token,
            widget.prescription.prescriptionId,
            newStatus,
            notes: notesController.text.isNotEmpty ? notesController.text : null,
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.statusUpdatedSuccess)));
            context.pop(); // Go back to dashboard to refresh
          }
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addExtraMedication() async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final frequencyController = TextEditingController();
    final durationController = TextEditingController();
    final unitController = TextEditingController();
    final quantityController = TextEditingController(text: '1');

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addMedication),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: l10n.medicationName)),
              TextField(controller: dosageController, decoration: InputDecoration(labelText: l10n.dosageLabel)),
              TextField(controller: frequencyController, decoration: InputDecoration(labelText: l10n.frequencyLabel)),
              TextField(controller: durationController, decoration: InputDecoration(labelText: l10n.durationLabel), keyboardType: TextInputType.number),
              TextField(controller: unitController, decoration: InputDecoration(labelText: l10n.unitLabel)),
              TextField(controller: quantityController, decoration: InputDecoration(labelText: l10n.quantityLabel), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) return;
              Navigator.pop(ctx, {
                'medicationName': nameController.text,
                'dosage': dosageController.text,
                'frequency': frequencyController.text,
                'duration': int.tryParse(durationController.text) ?? 1,
                'unit': unitController.text,
                'quantity': int.tryParse(quantityController.text) ?? 1,
              });
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => _isLoading = true);
      try {
        final token = await ref.read(authTokenProvider.future);
        if (token != null) {
          final data = {
            'prescriptionId': widget.prescription.prescriptionId,
            'medicationName': result['medicationName'],
            'dosage': result['dosage'],
            'frequency': result['frequency'],
            'duration': result['duration'],
            'unit': result['unit'],
            'quantity': result['quantity'],
          };
          await ref.read(createExtraMedicationProvider.notifier).createExtraMedication(token, data);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.medicationAddedToPrescription)));
            context.pop(); // Back to refresh
          }
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dispensePrescription),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: AppLocalizations.of(context)!.addMedication,
            onPressed: _addExtraMedication,
          ),
          IconButton(
            icon: const Icon(Icons.warning_amber),
            tooltip: AppLocalizations.of(context)!.checkInteractions,
            onPressed: _checkInteractions,
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: _updateStatus,
            itemBuilder: (ctx) => [
              PopupMenuItem(value: 2, child: Text(AppLocalizations.of(context)!.markAsFullyDispensed)),
              PopupMenuItem(value: 3, child: Text(AppLocalizations.of(context)!.cancelPrescription)),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context)!.patientLabel(widget.prescription.patientName), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    Text(AppLocalizations.of(context)!.drPrefix(widget.prescription.doctorName)),
                    Text(AppLocalizations.of(context)!.dateLabel(DateFormat('yyyy/MM/dd').format(widget.prescription.prescriptionDate))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Med List
            Text(AppLocalizations.of(context)!.medicationsTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.prescription.medications.length,
              itemBuilder: (context, index) {
                final item = widget.prescription.medications[index];
                final isDispensed = item.isDispensed;

                return Card(
                  color: isDispensed ? Colors.grey.shade100 : Colors.white,
                  child: CheckboxListTile(
                    value: isDispensed ? true : (_selectedItems[item.id] ?? false),
                    onChanged: isDispensed ? null : (val) {
                      setState(() {
                        _selectedItems[item.id ?? 0] = val ?? false;
                      });
                    },
                    title: Text(item.medicationName, style: TextStyle(decoration: isDispensed ? TextDecoration.lineThrough : null)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.dosage != null) Text(AppLocalizations.of(context)!.dosageLabelDispense(item.dosage!)),
                        if (item.instructions != null) Text(AppLocalizations.of(context)!.instructionsLabelDispense(item.instructions!), style: TextStyle(color: Colors.orange[800])),
                      ],
                    ),
                    secondary: isDispensed 
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.medication),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isLoading ? null : _dispense,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : Text(AppLocalizations.of(context)!.dispenseSelected, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
