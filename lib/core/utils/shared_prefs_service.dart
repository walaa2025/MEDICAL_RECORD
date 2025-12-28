
import 'package:shared_preferences/shared_preferences.dart';
// Importing Riverpod for state management.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This is a provider that will hold the instance of SharedPreferences.
// We use FutureProvider because SharedPreferences.getInstance() is asynchronous (takes time to load).
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  // We wait for the SharedPreferences to be ready and then return it.
  return await SharedPreferences.getInstance();
});

// This class handles saving and retrieving data from the device's storage.
// It uses SharedPreferences which is like a small database for simple settings.
class SharedPrefsService {
  // We need the SharedPreferences instance to do any work.
  final SharedPreferences _prefs;

  // This is the constructor. It runs when we create a new copy of this class.
  // It requires the SharedPreferences instance to be passed to it.
  SharedPrefsService(this._prefs);

  // This is a key we will use to save the theme setting (light or dark).
  static const String _themeKey = 'isDarkMode';

  // This function saves the user's choice of theme.
  // It takes a boolean (true/false) value: true for dark mode, false for light mode.
  Future<void> saveThemeMode(bool isDarkMode) async {
    // We call the setBool method on _prefs to save the value.
    // 'await' means we wait for the saving to finish before moving on.
    await _prefs.setBool(_themeKey, isDarkMode);
  }

  // This function gets the saved theme choice.
  // It returns a boolean: true if dark mode was saved, false otherwise.
  // If nothing was saved yet (first time user), it returns false (light mode by default).
  bool getThemeMode() {
    // We try to get the boolean value using the key.
    // ?? false means "if the result is null (not found), use false".
    return _prefs.getBool(_themeKey) ?? false;
  }

  // Key for storing the language code.
  static const String _langKey = 'languageCode';

  // Save the selected language code (e.g., 'en' or 'ar').
  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(_langKey, languageCode);
  }

  // Get the saved language code. Default is 'en' (English).
  String getLanguage() {
    return _prefs.getString(_langKey) ?? 'en';
  }
}

// This provider creates a SharedPrefsService for us to use in the app.
// It depends on the sharedPreferencesProvider we defined at the top.
final sharedPrefsServiceProvider = Provider<SharedPrefsService>((ref) {
  // We assume the sharedPreferencesProvider has loaded successfully.
  // We use .requireValue to get the actual SharedPreferences object.
  // CAUTION: This should only be used if we are sure the future has completed (e.g., in main() we wait for it).
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  
  // We return a new instance of our service, giving it the prefs object.
  return SharedPrefsService(prefs);
});
  
