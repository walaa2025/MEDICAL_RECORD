import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/l10n/app_localizations.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/pharmacist/presentation/providers/pharmacist_providers.dart';
import 'package:midical_record/core/theme/theme_service.dart';
import 'package:midical_record/core/utils/language_service.dart';
import 'package:midical_record/features/pharmacist/data/models/pharmacist_models.dart';
import 'package:midical_record/core/constants/app_enums.dart';

/// Pharmacist Dashboard Screen
/// Search-focused UI for finding patient prescriptions
class PharmacistDashboardScreen extends ConsumerStatefulWidget {
  const PharmacistDashboardScreen({super.key});

  @override
  ConsumerState<PharmacistDashboardScreen> createState() => _PharmacistDashboardScreenState();
}

class _PharmacistDashboardScreenState extends ConsumerState<PharmacistDashboardScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tokenAsync = ref.read(authTokenProvider);
      tokenAsync.whenData((token) {
        if (token != null) {
          ref.read(pharmacistProfileProvider.notifier).loadProfile(token);
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
        await ref.read(prescriptionSearchProvider.notifier).searchPrescriptions(token, _searchController.text);
      }
      
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = ref.watch(pharmacistProfileProvider);
    final searchState = ref.watch(prescriptionSearchProvider);

    return Scaffold(
      drawer: _buildDrawer(context, ref, profileState),
      appBar: AppBar(
        title: profileState.when(
          data: (profile) => Text(profile?.pharmacyName ?? AppLocalizations.of(context)!.pharmacist),
          loading: () => Text(AppLocalizations.of(context)!.pharmacist),
          error: (_, __) => Text(AppLocalizations.of(context)!.pharmacist),
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

            // Quick Stats
            _buildQuickStats(theme).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 24),

            // Search Results
            if (_isSearching)
              const Center(child: CircularProgressIndicator())
            else
              searchState.when(
                data: (results) {
                  if (results.isEmpty) {
                    return _buildEmptyState(theme);
                  }
                  return _buildSearchResults(results, theme);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(AppLocalizations.of(context)!.error(error.toString()), style: TextStyle(color: Colors.red.shade700)),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(theme),
    );
  }

  Widget _buildSearchCard(ThemeData theme) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade600, Colors.green.shade400],
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
                  AppLocalizations.of(context)!.findPrescription,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchPrescriptionHint,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: const Icon(Icons.person_search, color: Colors.white),
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

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _performSearch,
                    icon: const Icon(Icons.search),
                    label: Text(AppLocalizations.of(context)!.search),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.qrScannerSoon)),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 28),
                  label: Text(AppLocalizations.of(context)!.scanQR),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.pending_actions, size: 32, color: Colors.blue.shade700),
                  const SizedBox(height: 8),
                  const Text('12', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(AppLocalizations.of(context)!.pending, style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            elevation: 2,
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 32, color: Colors.green.shade700),
                  const SizedBox(height: 8),
                  const Text('45', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(AppLocalizations.of(context)!.dispensedToday, style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(List results, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.searchResultsWithCount(results.length),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...results.map((prescription) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(prescription.status).withOpacity(0.2),
                child: Icon(Icons.medication, color: _getStatusColor(prescription.status)),
              ),
              title: Text(prescription.patientName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(height: 4),
                  Text(AppLocalizations.of(context)!.patientCodeLabel(prescription.patientCode)),
                  Text(AppLocalizations.of(context)!.drPrefix(prescription.doctorName)),
                  Text(AppLocalizations.of(context)!.medicationsCount(prescription.medications.length)),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(prescription.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getStatusColor(prescription.status)),
                ),
                child: Text(
                  prescription.status.getLocalizedName(AppLocalizations.of(context)!),
                  style: TextStyle(
                    color: _getStatusColor(prescription.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              onTap: () {
                context.push('/pharmacist/dispense/${prescription.prescriptionId}', extra: prescription);
              },
            ),
          ).animate().fadeIn().slideX();
        }),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noPrescriptionsFound,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            ),
          ],
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

  Widget _buildBottomNavBar(ThemeData theme) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
       onTap: (index) {
        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            // History (to be implemented)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.historySoon)));
            break;
          case 2:
            context.push('/pharmacist/profile');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          activeIcon: const Icon(Icons.history),
          label: AppLocalizations.of(context)!.history,
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
              ref.read(authProvider).logout();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref, AsyncValue<PharmacistProfileModel?> profileState) {
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
                colors: [Colors.green.shade600, Colors.green.shade400],
              ),
            ),
            child: profileState.when(
              data: (profile) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(profile?.fullName[0] ?? "P", style: TextStyle(color: Colors.green.shade600, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(profile?.fullName ?? "", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(profile?.pharmacyName ?? l10n.pharmacist, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
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
                    context.push('/pharmacist/profile');
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
                            color: Colors.green,
                          ),
                          const SizedBox(width: 16),
                          Text(l10n.theme, style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Switch.adaptive(
                        value: themeMode == ThemeMode.dark,
                        activeColor: Colors.green,
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
                          Icon(Icons.language_rounded, color: Colors.green),
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
