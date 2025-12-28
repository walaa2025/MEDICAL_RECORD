
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:midical_record/l10n/app_localizations.dart';

// This screen allows the user to choose their role: Patient, Doctor, or Pharmacist.
class SignUpSelectionScreen extends StatelessWidget {
  const SignUpSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newAccount),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.whoAreYou,
                style: Theme.of(context).textTheme.headlineMedium,
              ).animate().fadeIn().slideY(begin: -0.5, end: 0),
              
              const SizedBox(height: 32),
              
              // Helper widget creates a selection card.
              _buildSelectionCard(
                context,
                title: l10n.patientRole,
                icon: Icons.person_outline,
                color: Colors.blue.shade100,
                onTap: () {
                  // Navigate to the Patient Sign Up Screen.
                  context.push('/signup_patient');
                },
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0),
              
              const SizedBox(height: 16),
              
              _buildSelectionCard(
                context,
                title: l10n.doctorRole,
                icon: Icons.medical_services_outlined,
                color: Colors.green.shade100,
                onTap: () {
                   context.push('/signup_doctor');
                },
              ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),
              
              const SizedBox(height: 16),
              
              _buildSelectionCard(
                context,
                title: l10n.pharmacistRole,
                icon: Icons.local_pharmacy_outlined,
                color: Colors.orange.shade100,
                onTap: () {
                  context.push('/signup_pharmacist');
                },
              ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  // A helper method to build the selection cards to avoid repeating code.
  Widget _buildSelectionCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    // InkWell provides the ripple effect on tap.
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 100, // Fixed height for consistency.
        width: double.infinity, // Take full width.
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color, // The pastel background color.
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4), // Shadow position.
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Circle.
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Icon(icon, size: 30, color: Colors.black54),
            ),
            const SizedBox(width: 24),
            // Title Text.
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            // Arrow indicator.
            const Icon(Icons.arrow_forward_ios, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
