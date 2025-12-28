import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:midical_record/core/services/token_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Artificial delay for the splash animation
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final token = await TokenStorageService.getToken();
    final role = await TokenStorageService.getUserRole();

    if (token != null && role != null) {
      // Navigate based on role
      switch (role.toLowerCase()) {
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
          context.go('/login');
      }
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Hero
          Hero(
            tag: 'login_bg',
            child: Image.asset(
              'assets/images/login_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Overlay to ensure text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.8),
                  Theme.of(context).primaryColor.withOpacity(0.9),
                ],
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with Hero
                Hero(
                  tag: 'app_logo',
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      height: 100,
                      width: 100,
                    ),
                  ),
                )
                .animate()
                .scale(duration: 800.ms, curve: Curves.easeOutBack)
                .shimmer(delay: 1000.ms, duration: 1500.ms),

                const SizedBox(height: 24),

                // App Name
                Text(
                  'Medical Record',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 8),

                Text(
                  'Your Health, Simplified',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
