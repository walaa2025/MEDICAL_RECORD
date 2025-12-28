
import 'package:flutter/material.dart';
// Importing Riverpod for state management visibility.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importing our Theme and Theme Service.
import 'package:midical_record/core/theme/app_theme.dart';
import 'package:midical_record/core/theme/theme_service.dart';
import 'package:midical_record/core/utils/app_router.dart';
// Importing Shared Prefs Service.
import 'package:midical_record/core/utils/shared_prefs_service.dart';
import 'package:midical_record/core/utils/language_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:midical_record/l10n/app_localizations.dart';

// The main function is the starting point of our Flutter app.
void main() async {
  // This line is needed to ensure that the Flutter engine is initialized 
  // before we try to do anything else, like loading Shared Preferences.
  WidgetsFlutterBinding.ensureInitialized();

  // We define a container for our providers.
  // This is manual setup so we can override the sharedPreferencesProvider 
  // with the actual loaded value before the app starts.
  final container = ProviderContainer();

  // We wait for the Shared Preferences to be ready.
  // container.read reads the provider once. .future get the Future object.
  final sharedPrefs = await container.read(sharedPreferencesProvider.future);

  // Now we run the app.
  runApp(
    // ProviderScope is the wrapper required by Riverpod to store all states.
    // We override the sharedPreferencesProvider with the value we just loaded.
    // This makes sure the data is ready immediately when the app starts.
    UncontrolledProviderScope(
      container: container,
      child: const MedicalRecordApp(),
    ),
  );
}

// This is the root widget of our application.
// We use ConsumerWidget so we can listen to providers (like the Theme).
class MedicalRecordApp extends ConsumerWidget {
  const MedicalRecordApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch the themeServiceProvider to know if we should be in Light or Dark mode.
    final themeMode = ref.watch(themeServiceProvider);
    // We watch the languageServiceProvider to know which locale to use.
    final locale = ref.watch(languageServiceProvider);

    return MaterialApp.router(
      // The title of the app.
      title: 'Medical Record',
      
      // We start with the debug banner off for a cleaner look.
      debugShowCheckedModeBanner: false,
      
      // We set the light theme design we created.
      theme: AppTheme.lightTheme,
      
      // We set the dark theme design we created.
      darkTheme: AppTheme.darkTheme,
      
      // We tell the app which mode to use based on the provider state.
      themeMode: themeMode,
      
      // Localization configuration
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Configure GoRouter
      routerConfig: goRouterProvider,
    );
  }
}
