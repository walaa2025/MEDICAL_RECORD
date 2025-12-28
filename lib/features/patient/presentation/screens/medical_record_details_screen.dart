import 'package:flutter/material.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:midical_record/features/patient/data/models/patient_models.dart';

class MedicalRecordDetailsScreen extends StatelessWidget {
  final MedicalRecordModel record;

  const MedicalRecordDetailsScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicalRecordDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      child: Icon(Icons.medical_services, size: 30, color: theme.primaryColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      record.diagnosis,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${record.recordDate.day}/${record.recordDate.month}/${record.recordDate.year}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Doctor Info
            _buildInfoCard(
              context,
              l10n.managingDoctor,
              Icons.person,
              l10n.drPrefix(record.doctorName),
            ),
            const SizedBox(height: 16),

            // Symptoms
            if (record.symptoms != null && record.symptoms!.isNotEmpty) ...[
               _buildInfoCard(
                context,
                l10n.symptoms,
                Icons.sick,
                record.symptoms!,
              ),
              const SizedBox(height: 16),
            ],

            // Treatment
            if (record.treatment != null && record.treatment!.isNotEmpty) ...[
               _buildInfoCard(
                context,
                l10n.treatment,
                Icons.healing,
                record.treatment!,
              ),
              const SizedBox(height: 16),
            ],

            // Notes
            if (record.notes != null && record.notes!.isNotEmpty) ...[
               _buildInfoCard(
                context,
                l10n.additionalNotes,
                Icons.note,
                record.notes!,
                isNote: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, IconData icon, String content, {bool isNote = false}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isNote ? Colors.grey[800] : null,
                fontStyle: isNote ? FontStyle.italic : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
