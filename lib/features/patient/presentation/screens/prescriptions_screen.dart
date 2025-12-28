import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/patient/presentation/providers/patient_providers.dart';
import 'package:midical_record/core/constants/app_enums.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

/// Prescriptions List Screen  
/// Shows all patient prescriptions with status filtering
class PrescriptionsScreen extends ConsumerStatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  ConsumerState<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends ConsumerState<PrescriptionsScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Load prescriptions when we have token
    // final token = ref.read(authTokenProvider);
    // ref.read(prescriptionsProvider.notifier).loadPrescriptions(token);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final prescriptionsState = ref.watch(prescriptionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.prescriptions),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter dialog
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh prescriptions
        },
        child: prescriptionsState.when(
          data: (prescriptions) {
            if (prescriptions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medication_outlined, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noPrescriptions,
                      style: theme.textTheme.titleLarge?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                final prescription = prescriptions[index];
                final statusColor = _getStatusColor(prescription.status);
                final statusText = prescription.status.getLocalizedName(l10n);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8)),
                    ],
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: InkWell(
                    onTap: () {
                      context.push('/patient/prescription/${prescription.id}', extra: prescription);
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(Icons.receipt_long_rounded, color: theme.primaryColor, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.doctorPrefix(prescription.doctorName),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('yyyy/MM/dd').format(prescription.prescriptionDate),
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          Row(
                            children: [
                              Text(l10n.medicationsLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  prescription.items.map((i) => i.medicationName).join(l10n.listSeparator),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${prescription.items.length}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1, end: 0);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.red),
                const SizedBox(height: 16),
                Text(l10n.error(error.toString()), style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Retry loading
                  },
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.pending:
        return Colors.orange;
      case PrescriptionStatus.partiallyDispensed:
        return Colors.blue;
      case PrescriptionStatus.fullyDispensed:
        return Colors.green;
      case PrescriptionStatus.cancelled:
        return Colors.red;
    }
  }
}
