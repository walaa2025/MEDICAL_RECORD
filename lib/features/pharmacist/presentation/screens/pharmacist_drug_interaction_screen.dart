import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/pharmacist/data/datasources/pharmacist_remote_data_source.dart';
import 'package:midical_record/l10n/app_localizations.dart';

/// Drug Interaction Check Screen
/// Allows pharmacists to check for drug interactions
class PharmacistDrugInteractionScreen extends ConsumerStatefulWidget {
  const PharmacistDrugInteractionScreen({super.key});

  @override
  ConsumerState<PharmacistDrugInteractionScreen> createState() => _PharmacistDrugInteractionScreenState();
}

class _PharmacistDrugInteractionScreenState extends ConsumerState<PharmacistDrugInteractionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _prescriptionIdController = TextEditingController();
  final List<TextEditingController> _medicationControllers = [];
  
  bool _isLoading = false;
  List<dynamic>? _warnings;
  bool? _hasInteractions;

  @override
  void initState() {
    super.initState();
    _addMedicationField(); // Start with one medication field
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _prescriptionIdController.dispose();
    for (var controller in _medicationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addMedicationField() {
    setState(() {
      _medicationControllers.add(TextEditingController());
    });
  }

  void _removeMedicationField(int index) {
    if (_medicationControllers.length > 1) {
      setState(() {
        _medicationControllers[index].dispose();
        _medicationControllers.removeAt(index);
      });
    }
  }

  Future<void> _checkInteractions() async {
    if (!_formKey.currentState!.validate()) return;
    
    final medications = _medicationControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
    
    if (medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.addAtLeastOneMedication)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await ref.read(authTokenProvider.future);
      if (token != null) {
        final dataSource = PharmacistRemoteDataSource();
        final interactions = await dataSource.checkDrugInteractions(
          token: token,
          medications: medications,
        );
        
        setState(() {
          _warnings = interactions.map((i) => {
            'medication1': i.medication1,
            'medication2': i.medication2,
            'severity': i.severity,
            'description': i.description,
            'recommendation': i.recommendation,
          }).toList();
          _hasInteractions = interactions.isNotEmpty;
        });
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

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
      case 'severe':
        return Colors.red;
      case 'medium':
      case 'moderate':
        return Colors.orange;
      case 'low':
      case 'mild':
        return Colors.yellow.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drugInteractionCheck),
        backgroundColor: Colors.purple,
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
                      color: Colors.purple.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.purple.shade700, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.checkDrugInteractionsInfo,
                                style: TextStyle(
                                  color: Colors.purple.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                    const SizedBox(height: 24),

                    // Patient ID (Optional)
                    TextFormField(
                      controller: _patientIdController,
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.patientId} (${AppLocalizations.of(context)!.optional})',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 16),

                    // Prescription ID (Optional)
                    TextFormField(
                      controller: _prescriptionIdController,
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.prescriptionId} (${AppLocalizations.of(context)!.optional})',
                        prefixIcon: const Icon(Icons.receipt_long),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                    ).animate().fadeIn(delay: 150.ms),
                    const SizedBox(height: 24),

                    // Medications Section
                    Text(
                      '${AppLocalizations.of(context)!.medications} *',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Medication Fields
                    ..._medicationControllers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final controller = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                decoration: InputDecoration(
                                  labelText: '${AppLocalizations.of(context)!.medication} ${index + 1}',
                                  hintText: 'e.g., Aspirin',
                                  prefixIcon: const Icon(Icons.medication),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (value) => (value == null || value.trim().isEmpty) && index == 0
                                    ? AppLocalizations.of(context)!.required
                                    : null,
                              ),
                            ),
                            if (_medicationControllers.length > 1)
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () => _removeMedicationField(index),
                              ),
                          ],
                        ).animate().fadeIn(delay: (200 + index * 50).ms).slideX(),
                      );
                    }),

                    // Add Medication Button
                    OutlinedButton.icon(
                      onPressed: _addMedicationField,
                      icon: const Icon(Icons.add),
                      label: Text(AppLocalizations.of(context)!.addMedication),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.purple, width: 2),
                        foregroundColor: Colors.purple,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 24),

                    // Results Section
                    if (_warnings != null) ...[
                      const Divider(thickness: 2),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.results,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (_hasInteractions == false)
                        Card(
                          color: Colors.green.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green, size: 32),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)!.noInteractionsFound,
                                    style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn().scale(),

                      if (_hasInteractions == true)
                        ..._warnings!.map((warning) {
                          final severity = warning['severity'] as String;
                          final color = _getSeverityColor(severity);
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: color, width: 2),
                                        ),
                                        child: Text(
                                          severity.toUpperCase(),
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${warning['medication1']} ↔ ${warning['medication2']}',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (warning['description'] != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      warning['description'],
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                  if (warning['recommendation'] != null) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.lightbulb_outline, color: Colors.blue, size: 20),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              warning['recommendation'],
                                              style: TextStyle(color: Colors.blue.shade900),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ).animate().fadeIn().slideY(begin: 0.2, end: 0);
                        }),
                    ],
                  ],
                ),
              ),
            ),

            // Check Button (Fixed at bottom)
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
                onPressed: _isLoading ? null : _checkInteractions,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.search),
                label: Text(_isLoading ? AppLocalizations.of(context)!.checking : AppLocalizations.of(context)!.checkInteractions),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
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
}
