
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midical_record/core/utils/shared_prefs_service.dart';

// This is the implementation of the Theme Controller using Riverpod.
// We use Notifier (Riverpod 2.0+) instead of StateNotifier.
class ThemeService extends Notifier<ThemeMode> {
  late SharedPrefsService _prefsService;

  @override
  ThemeMode build() {
    // We get the SharedPrefsService instance.
    _prefsService = ref.watch(sharedPrefsServiceProvider);
    
    // We get the saved theme mode.
    final isDarkMode = _prefsService.getThemeMode();
    
    // Return the initial state.
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // This function toggles the theme between light and dark.
  void toggleTheme() {
    // We check if the current state is dark mode.
    final isDark = state == ThemeMode.dark;
    
    // We switch the state to the opposite.
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    
    // We save the new choice to the storage.
    _prefsService.saveThemeMode(!isDark);
  }
}

// This provider gives us access to the ThemeService controller.
final themeServiceProvider = NotifierProvider<ThemeService, ThemeMode>(() {
  return ThemeService();
});
