import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/core/constants/app_enums.dart';
import 'package:intl/intl.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:midical_record/features/doctor/data/models/doctor_models.dart';
import 'package:midical_record/features/patient/data/models/patient_models.dart';

class DoctorPatientDetailsScreen extends ConsumerWidget {
  final PatientSearchResultModel patient;

  const DoctorPatientDetailsScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${patient.fullName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: View full history if needed
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Patient Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: theme.primaryColor,
                      child: Text(
                        patient.fullName[0].toUpperCase(),
                        style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      patient.fullName,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppLocalizations.of(context)!.codeLabel(patient.patientCode ?? ''),
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(context, AppLocalizations.of(context)!.gender, patient.gender.getLocalizedName(AppLocalizations.of(context)!)),
                        _buildStatItem(context, AppLocalizations.of(context)!.age, _calculateAge(patient.dateOfBirth)),
                        _buildStatItem(context, AppLocalizations.of(context)!.blood, patient.bloodType?.displayName ?? '-'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push('/doctor/add-record', extra: patient);
                    },
                    icon: const Icon(Icons.note_add),
                    label: Text(AppLocalizations.of(context)!.addRecord),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push('/doctor/add-prescription', extra: patient);
                    },
                    icon: const Icon(Icons.medication),
                    label: Text(AppLocalizations.of(context)!.addRx),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Critical Info (Allergies, Chronic)
            if (patient.allergies.isNotEmpty || patient.chronicDiseases.isNotEmpty)
              _buildCriticalInfo(context, patient),

            const SizedBox(height: 24),

            // Medical History Section
            _buildSectionHeader(context, AppLocalizations.of(context)!.medicalHistoryTitle),
            const SizedBox(height: 8),
            _buildMedicalHistoryList(context, patient.medicalRecords),

            const SizedBox(height: 24),

            // Prescriptions Section
            _buildSectionHeader(context, AppLocalizations.of(context)!.prescriptionsTitle),
            const SizedBox(height: 8),
            _buildPrescriptionsList(context, patient.prescriptions),
          ],
        ),
      ),
    );
  }

  String _calculateAge(DateTime? dob) {
    if (dob == null) return '-';
    final now = DateTime.now();
    final age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      return (age - 1).toString();
    }
    return age.toString();
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildCriticalInfo(BuildContext context, PatientSearchResultModel patient) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.red),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.criticalInformation, style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            if (patient.allergies.isNotEmpty) ...[
              Text('${AppLocalizations.of(context)!.allergies}:', style: const TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: patient.allergies.map((a) => Chip(
                  label: Text(a.allergenName),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  labelStyle: const TextStyle(fontSize: 12),
                )).toList(),
              ),
              const SizedBox(height: 8),
            ],
            if (patient.chronicDiseases.isNotEmpty) ...[
              Text('${AppLocalizations.of(context)!.chronicDiseases}:', style: const TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: patient.chronicDiseases.map((d) => Chip(
                  label: Text(d.diseaseName),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  labelStyle: const TextStyle(fontSize: 12),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildMedicalHistoryList(BuildContext context, List<MedicalRecordModel> records) {
    if (records.isEmpty) {
      return Card(child: Padding(padding: const EdgeInsets.all(16), child: Center(child: Text(AppLocalizations.of(context)!.noRecordsFound))));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.history, color: Colors.blue),
            title: Text(record.diagnosis),
            subtitle: Text('${AppLocalizations.of(context)!.drPrefix(record.doctorName)} • ${DateFormat('yyyy/MM/dd').format(record.recordDate)}'),
            onTap: () {
               // Show details dialog or navigate
               showDialog(
                 context: context,
                 builder: (context) => AlertDialog(
                   title: Text(record.diagnosis),
                   content: SingleChildScrollView(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(AppLocalizations.of(context)!.doctorLabel(record.doctorName)),
                         Text(AppLocalizations.of(context)!.dateLabel(_formatDate(record.recordDate))),
                         const Divider(),
                         if (record.symptoms != null) ...[
                           Text('${AppLocalizations.of(context)!.symptoms}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                           Text(record.symptoms!),
                           const SizedBox(height: 8),
                         ],
                         if (record.treatment != null) ...[
                           Text('${AppLocalizations.of(context)!.treatment}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                           Text(record.treatment!),
                           const SizedBox(height: 8),
                         ],
                         if (record.notes != null) ...[
                           Text('${AppLocalizations.of(context)!.notes}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                           Text(record.notes!),
                         ],
                       ],
                     ),
                   ),
                   actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.close))],
                 ),
               );
            },
          ),
        );
      },
    );
  }

  Widget _buildPrescriptionsList(BuildContext context, List<PrescriptionModel> prescriptions) {
     if (prescriptions.isEmpty) {
      return Card(child: Padding(padding: const EdgeInsets.all(16), child: Center(child: Text(AppLocalizations.of(context)!.noPrescriptionsFound))));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: prescriptions.length,
      itemBuilder: (context, index) {
        final px = prescriptions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.medication, color: Colors.green),
            title: Text(AppLocalizations.of(context)!.prescriptionNumber(px.id)),
            subtitle: Text('${AppLocalizations.of(context)!.drPrefix(px.doctorName)} • ${DateFormat('yyyy/MM/dd').format(px.prescriptionDate)}'),
            trailing: Text(px.status.getLocalizedName(AppLocalizations.of(context)!).toUpperCase(), style: const TextStyle(fontSize: 12)),
            onTap: () {
              // Show details
              context.push('/patient/prescription/${px.id}', extra: px);
            },
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }
}
