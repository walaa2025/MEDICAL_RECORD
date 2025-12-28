import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:midical_record/features/auth/presentation/providers/auth_providers.dart';
import 'package:midical_record/features/auth/data/models/auth_model.dart';
import 'package:midical_record/core/services/token_storage_service.dart';
import 'package:midical_record/l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nationalIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      ref.read(loginControllerProvider.notifier).login(
            _nationalIdController.text,
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final theme = Theme.of(context);

    // Listen for login state changes
    ref.listen<AsyncValue<LoginResponseModel?>>(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.loginFailed(error.toString())),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        data: (response) {
          if (response != null && response.success) {
            if (mounted) {
              final l10n = AppLocalizations.of(context)!;
              
              // Show success message with user info
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '✓ ${l10n.loginSuccessful}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Role: ${response.role}'),
                      Text('User ID: ${response.userId}'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 4),
                ),
              );

              // Navigate based on role
              switch (response.role.toLowerCase()) {
                case 'patient':
                  context.go('/patient/dashboard');
                  break;
                case 'doctor':
                  context.go('/doctor/dashboard');
                  break;
                case 'pharmacist':
                  context.go('/pharmacist/dashboard');
                  break;
                default:
                  context.go('/patient/dashboard');
              }
            }
          }
        },
      );
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        // GRADIENT BACKGROUND
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor,
              theme.colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo with Animation
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      // Use the custom logo asset
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        height: 80,
                        width: 80,
                      ),
                    ),
                  )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.easeOutBack)
                  .fadeIn(duration: 600.ms),

                  const SizedBox(height: 32),

                  // MAIN CARD
                  Card(
                    elevation: 8,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.welcomeBack,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.signInToAccount,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 32),

                            // National ID
                            TextFormField(
                              controller: _nationalIdController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.nationalId,
                                prefixIcon: const Icon(Icons.badge_outlined),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                                if (value.length < 10) return AppLocalizations.of(context)!.invalidId;
                                return null;
                              },
                            ).animate().fadeIn(delay: 200.ms).slideX(),

                            const SizedBox(height: 16),

                            // Password
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.password,
                                prefixIcon: const Icon(Icons.lock_outline),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                                if (value.length < 6) return AppLocalizations.of(context)!.tooShort;
                                return null;
                              },
                            ).animate().fadeIn(delay: 400.ms).slideX(),

                            const SizedBox(height: 32),

                            // Login Button
                            ElevatedButton(
                              onPressed: loginState.isLoading ? null : _onLoginPressed,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 56),
                                elevation: 0,
                              ),
                              child: loginState.isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(AppLocalizations.of(context)!.login.toUpperCase()),
                            ).animate().fadeIn(delay: 600.ms).scale(),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

                  const SizedBox(height: 32),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${AppLocalizations.of(context)!.dontHaveAccount} ", style: TextStyle(color: Colors.white.withOpacity(0.9))),
                      TextButton(
                        onPressed: () => context.push('/signup_selection'),
                        style: TextButton.styleFrom(foregroundColor: Colors.white),
                        child: Text(AppLocalizations.of(context)!.createAccount, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ).animate().fadeIn(delay: 800.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
