import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/patient/presentation/providers/patient_providers.dart';
import 'package:intl/intl.dart';
import 'package:midical_record/l10n/app_localizations.dart';

class PatientProfileScreen extends ConsumerStatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  ConsumerState<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends ConsumerState<PatientProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tokenAsync = ref.read(authTokenProvider);
      tokenAsync.whenData((token) {
        if (token != null) {
          ref.read(patientProfileProvider.notifier).loadProfile(token);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(patientProfileProvider);

    return Scaffold(
      body: profileState.when(
        data: (profile) {
          if (profile == null) {
            return Center(child: Text(l10n.profileNotFound));
          }
          return CustomScrollView(
            slivers: [
              // Aesthetic Sliver AppBar with Profile Info
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: theme.primaryColor.withOpacity(0.1),
                            child: Text(
                              profile.fullName.isNotEmpty ? profile.fullName[0].toUpperCase() : '?',
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: theme.primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile.fullName,
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          profile.email ?? "",
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
                    onPressed: () => context.push('/patient/profile/edit', extra: profile),
                  ),
                ],
              ),

              // Profile Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildPremiumSection(
                        context,
                        l10n.basicInfo,
                        Icons.person_rounded,
                        [
                          _InfoRow(l10n.dateOfBirth, profile.dateOfBirth != null ? DateFormat('yyyy/MM/dd').format(profile.dateOfBirth!) : '-'),
                          _InfoRow(l10n.gender, profile.gender.getLocalizedName(l10n)),
                          _InfoRow(l10n.bloodType, profile.bloodType?.displayName ?? '-'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildPremiumSection(
                        context,
                        l10n.biometrics,
                        Icons.straighten_rounded,
                        [
                          _InfoRow(l10n.weight, '${profile.weight ?? "-"} ${l10n.kg}'),
                          _InfoRow(l10n.height, '${profile.height ?? "-"} ${l10n.cm}'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildPremiumSection(
                        context,
                        l10n.contactInfo,
                        Icons.contact_phone_rounded,
                        [
                          _InfoRow(l10n.phoneNumber, profile.phoneNumber ?? '-'),
                          _InfoRow(l10n.address, profile.address ?? '-'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildPremiumSection(
                        context,
                        l10n.emergencyContact,
                        Icons.emergency_rounded,
                        [
                          _InfoRow(l10n.fullName, profile.emergencyContact ?? '-'),
                          _InfoRow(l10n.phoneNumber, profile.emergencyPhone ?? '-'),
                        ],
                        color: Colors.red,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        l10n.completeProfileNote,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.error(error.toString()))),
      ),
    );
  }

  Widget _buildPremiumSection(BuildContext context, String title, IconData icon, List<_InfoRow> rows, {Color? color}) {
    final theme = Theme.of(context);
    final primary = color ?? theme.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: primary),
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: primary)),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: rows.map((row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(row.label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    Text(row.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  _InfoRow(this.label, this.value);
}
