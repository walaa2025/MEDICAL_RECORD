import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/patient/presentation/providers/patient_providers.dart';
import 'package:intl/intl.dart';
import 'package:midical_record/l10n/app_localizations.dart';

/// Medical Records List Screen
/// Shows all patient medical records with filter/search
class MedicalRecordsScreen extends ConsumerStatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  ConsumerState<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends ConsumerState<MedicalRecordsScreen> {
  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tokenAsync = ref.read(authTokenProvider);
      tokenAsync.whenData((token) {
        if (token != null) {
          ref.read(medicalRecordsProvider.notifier).loadRecords(token);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final recordsState = ref.watch(medicalRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicalRecords),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final token = await ref.read(authTokenProvider.future);
          if (token != null) {
            await ref.read(medicalRecordsProvider.notifier).loadRecords(token);
          }
        },
        child: recordsState.when(
          data: (records) {
            if (records.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medical_services_outlined, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noRecords,
                      style: theme.textTheme.titleLarge?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
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
                    onTap: () => context.push('/patient/medical-record/${record.id}', extra: record),
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
                                child: Icon(Icons.medical_services_rounded, color: theme.primaryColor, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record.diagnosis,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.doctorPrefix(record.doctorName),
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
                            ],
                          ),
                          const Divider(height: 32),
                          Row(
                            children: [
                              Icon(Icons.calendar_month_rounded, size: 18, color: theme.primaryColor.withOpacity(0.5)),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('yyyy/MM/dd').format(record.recordDate),
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              if (record.notes != null && record.notes!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    l10n.notesAvailable,
                                    style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
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
}
