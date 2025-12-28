import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/doctor/presentation/providers/doctor_providers.dart';

/// Patient Medical Record View Screen
/// Read-only view of patient's complete medical history
class PatientRecordViewScreen extends ConsumerStatefulWidget {
  final String patientIdentifier;

  const PatientRecordViewScreen({super.key, required this.patientIdentifier});

  @override
  ConsumerState<PatientRecordViewScreen> createState() => _PatientRecordViewScreenState();
}

class _PatientRecordViewScreenState extends ConsumerState<PatientRecordViewScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // TODO: Load patient record
    // final token = ref.read(authTokenProvider);
    // ref.read(patientFullRecordProvider.notifier).loadPatientRecord(token, widget.patientIdentifier);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recordState = ref.watch(patientFullRecordProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Medical Record'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Profile'),
            Tab(icon: Icon(Icons.medical_services), text: 'History'),
            Tab(icon: Icon(Icons.warning_amber), text: 'Allergies'),
            Tab(icon: Icon(Icons.healing), text: 'Chronic'),
          ],
        ),
      ),
      body: recordState.when(
        data: (record) {
          if (record == null) {
            return const Center(child: Text('No patient data'));
          }
          return TabBarView(
            controller: _tabController,
            children: [
              _buildProfileTab(record, theme),
              _buildHistoryTab(record, theme),
              _buildAllergiesTab(record, theme),
              _buildChronicTab(record, theme),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildActionButtons(context, theme),
    );
  }

  Widget _buildProfileTab(record, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Patient Header Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: theme.primaryColor,
                    radius: 40,
                    child: Text(
                      record.fullName[0].toUpperCase(),
                      style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    record.fullName,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Patient Code: ${record.patientCode}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn().scale(),
          const SizedBox(height: 16),

          // Basic Information
          _buildInfoCard(
            theme,
            'Basic Information',
            Icons.info_outline,
            [
              _InfoRow('National ID', record.nationalId),
              _InfoRow('Date of Birth', '${record.dateOfBirth.day}/${record.dateOfBirth.month}/${record.dateOfBirth.year}'),
              _InfoRow('Gender', record.gender.displayNameEn),
              _InfoRow('Blood Type', record.bloodType?.displayName ?? 'Not specified'),
              if (record.height != null) _InfoRow('Height', '${record.height} cm'),
              if (record.weight != null) _InfoRow('Weight', '${record.weight} kg'),
            ],
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),

          // Contact Information
          _buildInfoCard(
            theme,
            'Contact Information',
            Icons.contact_phone,
            [
              if (record.phoneNumber != null) _InfoRow('Phone', record.phoneNumber!),
              if (record.email != null) _InfoRow('Email', record.email!),
              if (record.emergencyContactName != null) _InfoRow('Emergency Contact', record.emergencyContactName!),
              if (record.emergencyContactPhone != null) _InfoRow('Emergency Phone', record.emergencyContactPhone!),
            ],
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(record, ThemeData theme) {
    if (record.medicalHistory == null || record.medicalHistory!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No medical history', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: record.medicalHistory!.length,
      itemBuilder: (context, index) {
        final visit = record.medicalHistory![index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              child: Icon(Icons.medical_services, color: theme.primaryColor),
            ),
            title: Text(visit.diagnosis, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Dr. ${visit.doctorName}'),
                Text('${visit.visitDate.day}/${visit.visitDate.month}/${visit.visitDate.year}'),
                if (visit.notes != null) ...[
                  const SizedBox(height: 4),
                  Text(visit.notes!, style: TextStyle(color: Colors.grey.shade700)),
                ],
              ],
            ),
          ),
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }

  Widget _buildAllergiesTab(record, ThemeData theme) {
    if (record.allergies == null || record.allergies!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text('No known allergies', style: TextStyle(color: Colors.green.shade700)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: record.allergies!.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.orange.shade50,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
            title: Text(record.allergies![index]),
          ),
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }

  Widget _buildChronicTab(record, ThemeData theme) {
    if (record.chronicDiseases == null || record.chronicDiseases!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text('No chronic diseases', style: TextStyle(color: Colors.green.shade700)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: record.chronicDiseases!.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(Icons.medical_services, color: theme.primaryColor),
            title: Text(record.chronicDiseases![index]),
          ),
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }

  Widget _buildInfoCard(ThemeData theme, String title, IconData icon, List<_InfoRow> rows) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            ...rows.map((row) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140,
                    child: Text(
                      row.label,
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                  ),
                  Expanded(child: Text(row.value)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          onPressed: () {
            context.push('/doctor/add-diagnosis/${widget.patientIdentifier}');
          },
          icon: const Icon(Icons.note_add),
          label: const Text('Add Diagnosis'),
          backgroundColor: theme.primaryColor,
          heroTag: 'diagnosis',
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          onPressed: () {
            context.push('/doctor/create-prescription/${widget.patientIdentifier}');
          },
          icon: const Icon(Icons.medication),
          label: const Text('New Prescription'),
          backgroundColor: Colors.green,
          heroTag: 'prescription',
        ),
      ],
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  _InfoRow(this.label, this.value);
}
