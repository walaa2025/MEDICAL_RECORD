import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/doctor/presentation/providers/doctor_providers.dart';
import 'package:midical_record/core/theme/theme_service.dart';
import 'package:midical_record/core/utils/language_service.dart';

/// Doctor Dashboard Screen
/// Search-focused interface for finding patients
class DoctorDashboardScreen extends ConsumerStatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  ConsumerState<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends ConsumerState<DoctorDashboardScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tokenAsync = ref.read(authTokenProvider);
      tokenAsync.whenData((token) {
        if (token != null) {
          ref.read(doctorProfileProvider.notifier).loadProfile(token);
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() async {
    if (_searchController.text.isNotEmpty) {
      setState(() => _isSearching = true);
      
      final token = await ref.read(authTokenProvider.future);
      if (token != null) {
        await ref.read(patientSearchProvider.notifier).searchPatient(token, _searchController.text);
      }
      
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme =Theme.of(context);
    final profileState = ref.watch(doctorProfileProvider);
    final searchState = ref.watch(patientSearchProvider);

    return Scaffold(
      drawer: _buildDrawer(context, ref, profileState),
      appBar: AppBar(
        title: profileState.when(
          data: (profile) => Text(AppLocalizations.of(context)!.drPrefix(profile?.fullName ?? "")),
          loading: () => Text(AppLocalizations.of(context)!.doctor),
          error: (_, __) => Text(AppLocalizations.of(context)!.doctor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Search Card
            _buildSearchCard(theme).animate().fadeIn().slideY(begin: -0.2, end: 0),
            const SizedBox(height: 24),

            // Quick Access Section
            Text(
              AppLocalizations.of(context)!.quickAccess,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),
            _buildQuickAccessButtons(theme).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 24),

            // Search Results
            if (_isSearching)
              const Center(child: CircularProgressIndicator())
            else
              searchState.when(
                data: (result) {
                  if (result == null) {
                    return _buildRecentPatientsPlaceholder(theme);
                  }
                  return _buildSearchResult(result, theme);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      AppLocalizations.of(context)!.error(error.toString()),
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(theme),
    );
  }

  /// Main Search Card - Prominent feature
  Widget _buildSearchCard(ThemeData theme) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor,
              theme.primaryColor.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.search, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.findPatient,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search Input
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchHint,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: const Icon(Icons.badge_outlined, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
            const SizedBox(height: 16),

            // Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _performSearch,
                    icon: const Icon(Icons.search),
                    label: Text(AppLocalizations.of(context)!.search),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        final qrController = TextEditingController(text: "PAT-123456");
                        return AlertDialog(
                          title: Row(children: [const Icon(Icons.qr_code_scanner), const SizedBox(width: 8), Text(AppLocalizations.of(context)!.simulateScan)]),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(AppLocalizations.of(context)!.cameraNotAvailable),
                              const SizedBox(height: 16),
                              TextField(
                                controller: qrController,
                                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.qrCodeData),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)!.cancel)),
                            ElevatedButton(
                              onPressed: () {
                                _searchController.text = qrController.text;
                                Navigator.pop(ctx);
                                _performSearch();
                              },
                              child: Text(AppLocalizations.of(context)!.simulateRead),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 28),
                  label: Text(AppLocalizations.of(context)!.scanQR),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Quick Access Buttons
  Widget _buildQuickAccessButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.people_outline,
            label: AppLocalizations.of(context)!.recentPatients,
            color: Colors.blue.shade100,
            onTap: () {
              // TODO: Navigate to recent patients
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.message_outlined,
            label: AppLocalizations.of(context)!.messages,
            color: Colors.purple.shade100,
            onTap: () {
              // TODO: Navigate to messages
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.black87),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Search Result Card
  Widget _buildSearchResult(result, ThemeData theme) {
    return Card(
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor,
          radius: 28,
          child: Text(
            result.fullName[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          result.fullName,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.patientCodeLabel(result.patientCode)),
            Text(AppLocalizations.of(context)!.nationalIdLabel(result.nationalId)),
            if (result.bloodType != null) Text(AppLocalizations.of(context)!.bloodTypeLabel(result.bloodType!.displayName)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to patient full record
          context.push('/doctor/patient-record/${result.patientCode}', extra: result);
        },
      ),
    ).animate().fadeIn().slideX();
  }

  /// Recent Patients Placeholder
  Widget _buildRecentPatientsPlaceholder(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.searchPatientInstruction,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom Navigation Bar
  Widget _buildBottomNavBar(ThemeData theme) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            // TODO: Messages
            break;
          case 2:
            context.push('/doctor/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.message_outlined),
          activeIcon: const Icon(Icons.message),
          label: AppLocalizations.of(context)!.messages,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          activeIcon: const Icon(Icons.person),
          label: AppLocalizations.of(context)!.profile,
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref, AsyncValue<DoctorProfileModel?> profileState) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeServiceProvider);
    final locale = ref.watch(languageServiceProvider);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
              ),
            ),
            child: profileState.when(
              data: (profile) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(profile?.fullName[0] ?? "D", style: TextStyle(color: theme.primaryColor, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.drPrefix(profile?.fullName ?? ""), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(profile?.specialization ?? l10n.doctor, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
              error: (_, __) => const Center(child: Icon(Icons.error, color: Colors.white)),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home_rounded,
                  label: l10n.home,
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.person_rounded,
                  label: l10n.profile,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/doctor/profile');
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
    );
  }
}
