import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/patient/presentation/providers/patient_providers.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';
import 'package:midical_record/l10n/app_localizations.dart';

/// Emergency Screen with QR Code
/// Shows patient emergency information and QR code
class EmergencyScreen extends ConsumerStatefulWidget {
  const EmergencyScreen({super.key});

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tokenAsync = ref.read(authTokenProvider);
      tokenAsync.whenData((token) {
        if (token != null) {
           ref.read(emergencyDataProvider.notifier).loadEmergencyData(token);
           ref.read(patientQrProvider.notifier).generateQr(token);
        }
      });
    });
  }

  Future<void> _saveAsImage() async {
    setState(() => _isSaving = true);
    try {
      final Uint8List? image = await _screenshotController.capture();
      if (image != null) {
        final result = await ImageGallerySaver.saveImage(image, quality: 100, name: "emergency_info_${DateTime.now().millisecondsSinceEpoch}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.saveImageSuccess)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.saveImageError(e.toString())), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final emergencyDataState = ref.watch(emergencyDataProvider);
    final qrState = ref.watch(patientQrProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.emergency),
        backgroundColor: Colors.red.shade700,
        actions: [
          IconButton(
            icon: _isSaving ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : const Icon(Icons.download),
            onPressed: _isSaving ? null : _saveAsImage,
            tooltip: l10n.saveAsImage,
          ),
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Container(
          color: Colors.white, // Ensure white background for screenshot
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Warning Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade300, width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.emergencyCriticalNote,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                const SizedBox(height: 24),

                // QR Code Card
                _buildQRCard(theme, qrState, l10n),
                const SizedBox(height: 24),

                // Emergency Information
                emergencyDataState.when(
                  data: (data) {
                    if (data == null) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(l10n.noEmergencyInfo, textAlign: TextAlign.center),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        _buildInfoCard(
                          theme,
                          l10n.basicInfo,
                          Icons.person,
                          [
                            _InfoRow(l10n.fullName, data.fullName),
                            _InfoRow(l10n.bloodType, data.bloodType?.displayName ?? l10n.notSpecified),
                          ],
                        ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 16),
                        
                        if (data.allergies.isNotEmpty)
                          _buildInfoCard(
                            theme,
                            l10n.allergies,
                            Icons.warning_amber_rounded,
                            data.allergies.map((allergy) => _InfoRow('•', allergy)).toList(),
                            color: Colors.orange.shade50,
                          ).animate().fadeIn(delay: 400.ms),
                        const SizedBox(height: 16),
                        
                        if (data.chronicDiseases.isNotEmpty)
                          _buildInfoCard(
                            theme,
                            l10n.chronicDiseases,
                            Icons.medical_services,
                            data.chronicDiseases.map((disease) => _InfoRow('•', disease)).toList(),
                          ).animate().fadeIn(delay: 500.ms),
                        const SizedBox(height: 16),
                        
                        if (data.currentMedications.isNotEmpty)
                          _buildInfoCard(
                            theme,
                            l10n.currentMedications,
                            Icons.medication,
                            data.currentMedications.map((med) => _InfoRow('•', med)).toList(),
                          ).animate().fadeIn(delay: 600.ms),
                        const SizedBox(height: 16),
                        
                        if (data.emergencyContact != null)
                          _buildInfoCard(
                            theme,
                            l10n.emergencyContact,
                            Icons.contact_phone,
                            [
                              _InfoRow(l10n.fullName, data.emergencyContact ?? ''),
                              _InfoRow(l10n.phoneNumber, data.emergencyPhone ?? ''),
                            ],
                            color: Colors.blue.shade50,
                          ).animate().fadeIn(delay: 700.ms),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.error(error.toString()), style: const TextStyle(color: Colors.red)),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                // Footnote
                Center(
                  child: Text(
                    l10n.generatedByApp,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQRCard(ThemeData theme, AsyncValue<String?> qrState, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor.withOpacity(0.1),
            Colors.purple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: theme.primaryColor.withOpacity(0.3), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_2_rounded, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    l10n.emergencyQrCode,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              qrState.when(
                data: (qrCode) {
                  if (qrCode == null || qrCode.isEmpty) return _buildPlaceholderQR(theme);
                  final bytes = base64Decode(qrCode.split(',').last);
                  return Image.memory(bytes, width: 200, height: 200);
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => const Icon(Icons.error, size: 100, color: Colors.red),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.scanQrNote,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderQR(ThemeData theme) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.qr_code, size: 100, color: Colors.grey),
    );
  }

  Widget _buildInfoCard(ThemeData theme, String title, IconData icon, List<_InfoRow> rows, {Color? color}) {
    return Card(
      elevation: 2,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.primaryColor),
                const SizedBox(width: 12),
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            ...rows.map((row) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(width: 100, child: Text(row.label, style: const TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text(row.value)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  _InfoRow(this.label, this.value);
}

