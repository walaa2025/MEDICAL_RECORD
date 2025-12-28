import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/patient/presentation/providers/patient_providers.dart';
import 'package:midical_record/core/theme/theme_service.dart';
import 'package:midical_record/core/utils/language_service.dart';
import 'package:intl/intl.dart';
import 'package:midical_record/l10n/app_localizations.dart';

/// Patient Dashboard Screen
/// Main home screen for patients with:
/// - Emergency Card
/// - Quick Actions (2x2 grid)
/// - Latest Prescriptions
class PatientDashboardScreen extends ConsumerStatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  ConsumerState<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends ConsumerState<PatientDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to safely read provider after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tokenAsync = ref.read(authTokenProvider);
      tokenAsync.whenData((token) {
        if (token != null) {
          ref.read(patientProfileProvider.notifier).loadProfile(token);
          ref.read(prescriptionsProvider.notifier).loadPrescriptions(token);
          ref.read(emergencyDataProvider.notifier).loadEmergencyData(token);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(patientProfileProvider);
    final prescriptionsState = ref.watch(prescriptionsProvider);

    return Scaffold(
      drawer: _buildDrawer(context, ref, profileState),
      appBar: AppBar(
        title: profileState.when(
          data: (profile) => Text(l10n.welcomeMessage(profile?.fullName.split(' ').first ?? l10n.profile)),
          loading: () => Text(l10n.profile),
          error: (_, __) => Text(l10n.profile),
        ),
        actions: [
          // Notifications with premium badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 28),
                onPressed: () => context.push('/notifications'),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          // Logout with confirmation
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _showLogoutDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final token = await ref.read(authTokenProvider.future);
          if (token != null) {
            await Future.wait([
               ref.read(patientProfileProvider.notifier).loadProfile(token),
               ref.read(prescriptionsProvider.notifier).loadPrescriptions(token),
            ]);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Initialization Banner (Premium Version)
              profileState.when(
                data: (profile) => profile == null || profile.bloodType == null
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange.shade400, Colors.orange.shade700],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_rounded, color: Colors.white, size: 32),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                l10n.incompleteProfileMessage,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => context.push('/patient/initialize-profile'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.orange.shade700,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(l10n.initialize),
                            ),
                          ],
                        ),
                      ).animate().scale(delay: 500.ms, duration: 400.ms, curve: Curves.easeOutBack)
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              
              // Emergency Section
              Text(
                l10n.emergencyAlert,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildModernEmergencyCard(theme).animate().fadeIn().slideX(begin: 0.1, end: 0),
              const SizedBox(height: 32),

              // Quick Actions
              Text(
                l10n.quickActions,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildQuickActionsGrid(theme),
              const SizedBox(height: 32),

              // Latest Prescriptions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.latestPrescriptions,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => context.push('/patient/prescriptions'),
                    child: Text(l10n.viewAll),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildLatestPrescriptions(prescriptionsState, theme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(theme),
    );
  }

  /// Emergency Card - Prominent red-tinted card
  Widget _buildModernEmergencyCard(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.red.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.emergency, size: 150, color: Colors.white.withOpacity(0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.needEmergencyHelp,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.emergencyNote,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildEmergencyActionButton(
                        label: l10n.emergencyDataAction,
                        icon: Icons.info_rounded,
                        onTap: () => context.push('/patient/emergency'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildEmergencyActionButton(
                        label: l10n.qrCodeAction,
                        icon: Icons.qr_code_2_rounded,
                        onTap: () => context.push('/patient/emergency'), // Navigate to emergency screen where QR is
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyActionButton({required String label, required IconData icon, required VoidCallback onTap, bool isPrimary = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isPrimary ? Colors.red.shade700 : Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.red.shade700 : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ).animate(onPlay: (c) => isPrimary ? c.repeat(reverse: true) : null).shimmer(duration: 3.seconds, delay: 2.seconds);
  }

  /// Quick Actions - 2x2 Grid
  Widget _buildQuickActionsGrid(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final actions = [
      _QuickAction(
        icon: Icons.assignment_rounded,
        label: l10n.medicalRecords,
        color: Colors.blue,
        onTap: () => context.push('/patient/medical-records'),
      ),
      _QuickAction(
        icon: Icons.medication_rounded,
        label: l10n.prescriptions,
        color: Colors.green,
        onTap: () => context.push('/patient/prescriptions'),
      ),
      _QuickAction(
        icon: Icons.person_rounded,
        label: l10n.profile,
        color: Colors.purple,
        onTap: () => context.push('/patient/profile'),
      ),
      _QuickAction(
        icon: Icons.settings_rounded,
        label: l10n.settings,
        color: Colors.blueGrey,
        onTap: () => context.push('/settings'),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: action.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(action.icon, size: 28, color: action.color),
                ),
                const SizedBox(height: 12),
                Text(
                  action.label,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ).animate().scale(delay: (index * 100).ms, duration: 400.ms, curve: Curves.easeOut);
      },
    );
  }

  /// Latest Prescriptions Section
  Widget _buildLatestPrescriptions(AsyncValue<List> prescriptionsState, ThemeData theme) {
    return prescriptionsState.when(
      data: (prescriptions) {
        if (prescriptions.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(Icons.medical_services_outlined, size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text(AppLocalizations.of(context)!.noPrescriptionsFound, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        final latestPrescriptions = prescriptions.take(3).toList();
        return Column(
          children: latestPrescriptions.asMap().entries.map((entry) {
            final index = entry.key;
            final prescription = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
                border: Border.all(color: Colors.grey.shade50),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.receipt_long_rounded, color: Colors.green),
                ),
                title: Text(AppLocalizations.of(context)!.drPrefix(prescription.doctorName), style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  DateFormat('yyyy/MM/dd').format(prescription.prescriptionDate),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () => context.push('/patient/prescription/${prescription.id}'),
              ),
            ).animate().fadeIn(delay: (index * 150).ms).slideX(begin: 0.1, end: 0);
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text(AppLocalizations.of(context)!.error(error.toString()), style: const TextStyle(color: Colors.red)),
    );
  }

  void _showLogoutDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text(l10n.logout),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
    if (confirmed == true) {
      context.go('/login');
    }
  }

  /// Bottom Navigation Bar
  Widget _buildDrawer(BuildContext context, WidgetRef ref, AsyncValue profileState) {
    final themeMode = ref.watch(themeServiceProvider);
    final locale = ref.watch(languageServiceProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: Column(
        children: [
          // Premium Drawer Header
          profileState.when(
            data: (profile) => UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  profile?.fullName.isNotEmpty == true ? profile!.fullName[0].toUpperCase() : "?",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: theme.primaryColor),
                ),
              ),
              accountName: Text(
                profile?.fullName ?? l10n.profile,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(profile?.email ?? ""),
            ),
            loading: () => DrawerHeader(
              decoration: BoxDecoration(color: theme.primaryColor),
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
            error: (_, __) => DrawerHeader(
              decoration: BoxDecoration(color: theme.primaryColor),
              child: Center(child: Text(l10n.loadingError, style: const TextStyle(color: Colors.white))),
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.person_outline_rounded,
                  label: l10n.profile,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/patient/profile');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.history_rounded,
                  label: l10n.medicalRecords,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/patient/medical-records');
                  },
                ),
                const Divider(indent: 20, endIndent: 20),
                
                // Theme Toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            themeMode == ThemeMode.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 16),
                          Text(l10n.theme, style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Switch.adaptive(
                        value: themeMode == ThemeMode.dark,
                        activeColor: theme.primaryColor,
                        onChanged: (value) {
                          ref.read(themeServiceProvider.notifier).toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),

                // Language Selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.language_rounded, color: theme.primaryColor),
                          const SizedBox(width: 16),
                          Text(l10n.language, style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      DropdownButton<String>(
                        value: locale.languageCode,
                        underline: const SizedBox(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            ref.read(languageServiceProvider.notifier).setLanguage(newValue);
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: 'ar', child: Text('العربية')),
                          DropdownMenuItem(value: 'en', child: Text('English')),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const Divider(indent: 20, endIndent: 20),
                _buildDrawerItem(
                  icon: Icons.logout_rounded,
                  label: l10n.logout,
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
          
          // App Version or Logo at bottom
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'v1.0.0',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Widget _buildBottomNavBar(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0: break;
            case 1: context.push('/patient/medical-records'); break;
            case 2: context.push('/patient/prescriptions'); break;
            case 3: context.push('/patient/profile'); break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_filled), label: l10n.home),
          BottomNavigationBarItem(icon: const Icon(Icons.assignment_rounded), label: l10n.records),
          BottomNavigationBarItem(icon: const Icon(Icons.medication_rounded), label: l10n.meds),
          BottomNavigationBarItem(icon: const Icon(Icons.person_rounded), label: l10n.profileShort),
        ],
      ),
    );
  }
}

/// Quick Action Data Model
class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
