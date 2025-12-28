import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/pharmacist/data/datasources/pharmacist_remote_data_source.dart';
import 'package:midical_record/features/pharmacist/data/models/pharmacist_models.dart';
import 'package:midical_record/core/constants/app_enums.dart';
import 'package:midical_record/l10n/app_localizations.dart';

/// Prescription Search Screen
/// Allows pharmacists to search for prescriptions by patient identifier
class PharmacistSearchPrescriptionScreen extends ConsumerStatefulWidget {
  const PharmacistSearchPrescriptionScreen({super.key});

  @override
  ConsumerState<PharmacistSearchPrescriptionScreen> createState() => _PharmacistSearchPrescriptionScreenState();
}

class _PharmacistSearchPrescriptionScreenState extends ConsumerState<PharmacistSearchPrescriptionScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;
  List<PrescriptionSearchResultModel>? _prescriptions;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchPrescriptions() async {
    if (_searchController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.enterPatientIdentifier)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await ref.read(authTokenProvider.future);
      if (token != null) {
        final dataSource = PharmacistRemoteDataSource();
        final results = await dataSource.searchPrescription(
          token: token,
          identifier: _searchController.text.trim(),
        );
        
        setState(() {
          _prescriptions = results;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.searchPrescription),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal.shade50,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.enterNationalIdOrPatientCode,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _prescriptions = null);
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _searchPrescriptions(),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _searchPrescriptions,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.search),
                  label: Text(_isLoading ? AppLocalizations.of(context)!.searching : AppLocalizations.of(context)!.search),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          // Results
          Expanded(
            child: _prescriptions == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.searchForPrescriptions,
                          style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : _prescriptions!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noPrescriptionsFound,
                              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _prescriptions!.length,
                        itemBuilder: (context, index) {
                          final prescription = _prescriptions![index];
                          return _buildPrescriptionCard(prescription, theme);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(PrescriptionSearchResultModel prescription, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: InkWell(
        onTap: () {
          // Navigate to dispense screen or details
          context.push('/pharmacist/dispense/${prescription.prescriptionId}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.prescription} #${prescription.prescriptionId}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(prescription.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(prescription.status),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      prescription.status.name.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(prescription.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Patient Info
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    '${AppLocalizations.of(context)!.patient}: ${prescription.patientName}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Doctor Info
              Row(
                children: [
                  Icon(Icons.medical_services, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    '${AppLocalizations.of(context)!.doctor}: ${prescription.doctorName}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    '${AppLocalizations.of(context)!.date}: ${prescription.prescriptionDate.toString().split(' ')[0]}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Medications
              const Divider(),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.medications} (${prescription.medications.length})',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...prescription.medications.take(3).map((med) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      med.isDispensed ? Icons.check_circle : Icons.circle_outlined,
                      size: 16,
                      color: med.isDispensed ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${med.medicationName} - ${med.dosage ?? "N/A"}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
              if (prescription.medications.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+ ${prescription.medications.length - 3} ${AppLocalizations.of(context)!.more}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100).ms).slideY(begin: 0.2, end: 0);
  }
}
