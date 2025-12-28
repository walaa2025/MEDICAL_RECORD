import 'package:flutter/material.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:midical_record/features/patient/data/models/patient_models.dart';
import 'package:midical_record/core/constants/app_enums.dart';

class PrescriptionDetailsScreen extends StatelessWidget {
  final PrescriptionModel prescription;

  const PrescriptionDetailsScreen({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.prescriptionDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Banner
            _buildStatusBanner(context, prescription.status),
            const SizedBox(height: 16),

            // Info Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      child: Icon(Icons.medication, size: 30, color: theme.primaryColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.drPrefix(prescription.doctorName),
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('yyyy/MM/dd').format(prescription.prescriptionDate),
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Diagnosis
            if (prescription.diagnosis != null) ...[
              Text(l10n.diagnosis, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(prescription.diagnosis!, style: theme.textTheme.bodyLarge),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Medications
            Text(l10n.medicationsTitle, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prescription.items.length,
              itemBuilder: (context, index) {
                final item = prescription.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(Icons.medication_liquid, color: theme.primaryColor),
                    title: Text(item.medicationName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.dosage != null) Text(l10n.dosageLabelDispense(item.dosage!)),
                        if (item.frequency != null) Text(l10n.frequencyLabelValue(item.frequency!)),
                        if (item.duration != null) Text(l10n.durationLabelValue(item.duration!)),
                        if (item.instructions != null) Text(item.instructions!, style: TextStyle(color: Colors.orange[800])),
                      ],
                    ),
                    trailing: item.isDispensed 
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.pending, color: Colors.grey),
                  ),
                );
              },
            ),

            // Notes
            if (prescription.notes != null && prescription.notes!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(l10n.notes, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
               Card(
                color: Colors.yellow[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(prescription.notes!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context, PrescriptionStatus status) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    IconData icon;
    String text = status.getLocalizedName(l10n);

    switch (status) {
      case PrescriptionStatus.pending:
        color = Colors.orange;
        icon = Icons.hourglass_top;
        break;
      case PrescriptionStatus.partiallyDispensed:
        color = Colors.blue;
        icon = Icons.timelapse;
        break;
      case PrescriptionStatus.fullyDispensed:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case PrescriptionStatus.cancelled:
        color = Colors.red;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
