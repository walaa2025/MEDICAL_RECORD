
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midical_record/core/utils/shared_prefs_service.dart';

// This controller manages the active language of the app.
// It stores a Locale object (e.g., Locale('en') or Locale('ar')).
class LanguageService extends Notifier<Locale> {
  // Migration to Riverpod 3.0 Notifier: use build() instead of constructor

  @override
  Locale build() {
    final prefsService = ref.watch(sharedPrefsServiceProvider);
    return Locale(prefsService.getLanguage());
  }

  // Switch to a specific language code.
  void setLanguage(String languageCode) {
    // Check if we are already on this language to avoid unnecessary updates.
    if (state.languageCode == languageCode) return;

    // Update the state (this triggers the UI to rebuild).
    state = Locale(languageCode);
    
    // Save to storage.
    ref.read(sharedPrefsServiceProvider).saveLanguage(languageCode);
  }

  // Helper to toggle between English and Arabic (common for this region).
  void toggleLanguage() {
    if (state.languageCode == 'en') {
      setLanguage('ar');
    } else {
      setLanguage('en');
    }
  }
}

// Provider for the LanguageService.
final languageServiceProvider = NotifierProvider<LanguageService, Locale>(LanguageService.new);
