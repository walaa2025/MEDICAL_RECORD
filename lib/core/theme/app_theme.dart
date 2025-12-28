
import 'package:flutter/material.dart';

// This class holds all the design rules for our app, like colors and text styles.
class AppTheme {
  
  // PRIMARY PALETTE: Deep Trust Blue & Calming Teal
  static const Color primaryColor = Color(0xFF0F4C81); // Classic Blue (Professional, Trust)
  static const Color secondaryColor = Color(0xFF00BFA5); // Medical Teal (Calm, Health)
  static const Color accentColor = Color(0xFFE0F7FA); // Very Light Cyan for backgrounds

  // BACKGROUNDS
  static const Color scaffoldBackgroundColorLight = Color(0xFFF8F9FA); // Clean White/Grey
  static const Color scaffoldBackgroundColorDark = Color(0xFF101820); // Deep Blue/Black
  static const Color surfaceColorDark = Color(0xFF1F2933);
  static const Color accentColorDark = Color(0xFF64B5F6);

  // ERROR
  static const Color errorColor = Color(0xFFD32F2F); // Standard Red

  // SHAPE CONSTANTS
  static final BorderRadius defaultRadius = BorderRadius.circular(16);
  static final BorderRadius buttonRadius = BorderRadius.circular(30); // Pill shape

  // FONTS
  static const String fontFamily = 'Outfit';
  static const List<String> fontFamilyFallback = ['Tajawal']; // Arabic Fallback

  // --- LIGHT THEME ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColorLight,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: Colors.white,
        onSurface: Colors.black87,
      ),

      // AppBar: Clean, minimal, white with dark text (Modern look)
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor, 
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: primaryColor, 
          fontSize: 20, 
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),

      // Buttons: Pill shaped, prominent
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: buttonRadius),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Inputs: Modern, filled, no visible border until focused
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIconColor: primaryColor,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: defaultRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: defaultRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: defaultRadius,
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),

      // Cards: Elegant elevation
      // Using CardThemeData instead of CardTheme wrapper to satisfy ThemeData type check.
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: defaultRadius),
        margin: EdgeInsets.zero, // We handle margins manually
      ),

      // Navigation Bar: Sleek and modern
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primaryColor.withOpacity(0.1),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: primaryColor),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryColor, size: 26);
          }
          return const IconThemeData(color: Colors.grey, size: 24);
        }),
      ),

      // Dialogs: Deeply rounded
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        contentTextStyle: const TextStyle(color: Color(0xFF636e72), fontSize: 16),
      ),

      // SnackBars: Floating and rounded
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2D3436),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),

      // Typography
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E272E), letterSpacing: -0.5),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E272E)),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF2d3436), height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF636e72), height: 1.5),
      ),
    );
  }

  // --- DARK THEME ---
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColorDark,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,

      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColorDark,
        error: errorColor,
        surface: surfaceColorDark,
        onSurface: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: buttonRadius),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B).withOpacity(0.5),
        prefixIconColor: accentColorDark,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        border: OutlineInputBorder(
          borderRadius: defaultRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: defaultRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: defaultRadius,
          borderSide: const BorderSide(color: accentColorDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      cardTheme: CardThemeData(
        color: surfaceColorDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: defaultRadius,
          side: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
        ),
      ),

      // Navigation Bar Dark
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scaffoldBackgroundColorDark,
        indicatorColor: accentColorDark.withOpacity(0.1),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),

      // Dialogs Dark
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColorDark,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        contentTextStyle: const TextStyle(color: Colors.white70, fontSize: 16),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white70),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: accentColorDark),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
      ),
    );
  }
}
