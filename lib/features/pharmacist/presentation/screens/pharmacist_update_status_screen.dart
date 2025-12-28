import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/pharmacist/data/datasources/pharmacist_remote_data_source.dart';
import 'package:midical_record/core/constants/app_enums.dart';
import 'package:midical_record/l10n/app_localizations.dart';

/// Prescription Status Update Screen
/// Allows pharmacists to update prescription status
class PharmacistUpdateStatusScreen extends ConsumerStatefulWidget {
  final int? prescriptionId;
  
  const PharmacistUpdateStatusScreen({super.key, this.prescriptionId});

  @override
  ConsumerState<PharmacistUpdateStatusScreen> createState() => _PharmacistUpdateStatusScreenState();
}

class _PharmacistUpdateStatusScreenState extends ConsumerState<PharmacistUpdateStatusScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prescriptionIdController = TextEditingController();
  final _notesController = TextEditingController();
  
  PrescriptionStatus? _selectedStatus;
  bool _isLoading = false;
  int? _updatedStatus;

  @override
  void initState() {
    super.initState();
    if (widget.prescriptionId != null) {
      _prescriptionIdController.text = widget.prescriptionId.toString();
    }
  }

  @override
  void dispose() {
    _prescriptionIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectStatus)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await ref.read(authTokenProvider.future);
      if (token != null) {
        final dataSource = PharmacistRemoteDataSource();
        final response = await dataSource.updatePrescriptionStatus(
          token: token,
          prescriptionId: int.parse(_prescriptionIdController.text),
          status: _selectedStatus!.value,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
        
        setState(() {
          _updatedStatus = response['newStatus'] as int?;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? AppLocalizations.of(context)!.statusUpdatedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
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
        title: Text(AppLocalizations.of(context)!.updatePrescriptionStatus),
        backgroundColor: Colors.indigo,
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
                      color: Colors.indigo.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.update, color: Colors.indigo.shade700, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.updateStatusInfo,
                                style: TextStyle(
                                  color: Colors.indigo.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                    const SizedBox(height: 24),

                    // Prescription ID
                    TextFormField(
                      controller: _prescriptionIdController,
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.prescriptionId} *',
                        prefixIcon: const Icon(Icons.receipt_long),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? AppLocalizations.of(context)!.required
                          : null,
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 16),

                    // Status Dropdown
                    DropdownButtonFormField<PrescriptionStatus>(
                      value: _selectedStatus,
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.newStatus} *',
                        prefixIcon: const Icon(Icons.label),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: PrescriptionStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(status.name.toUpperCase()),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedStatus = value);
                      },
                      validator: (value) => value == null
                          ? AppLocalizations.of(context)!.selectStatus
                          : null,
                    ).animate().fadeIn(delay: 150.ms),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.notes} (${AppLocalizations.of(context)!.optional})',
                        hintText: AppLocalizations.of(context)!.reasonForStatusChange,
                        prefixIcon: const Icon(Icons.note_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      maxLines: 4,
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 24),

                    // Result Display
                    if (_updatedStatus != null) ...[
                      const Divider(thickness: 2),
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.green.shade50,
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                AppLocalizations.of(context)!.statusUpdatedSuccessfully,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${AppLocalizations.of(context)!.newStatus}: ${PrescriptionStatus.fromValue(_updatedStatus!).name.toUpperCase()}',
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn().scale(),
                    ],
                  ],
                ),
              ),
            ),

            // Update Button (Fixed at bottom)
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
                onPressed: _isLoading ? null : _updateStatus,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? AppLocalizations.of(context)!.updating : AppLocalizations.of(context)!.updateStatus),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
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

  Color _getStatusColor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.pending:
        return Colors.orange;
      case PrescriptionStatus.dispensed:
        return Colors.green;
      case PrescriptionStatus.cancelled:
        return Colors.red;
      case PrescriptionStatus.partiallyDispensed:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
