import 'package:flutter/material.dart';

/// Centralized mint/white theme for NekoPix.
class AppTheme {
  AppTheme._();

  // ── Brand Colors ──────────────────────────────────────────────────────────
  static const Color primaryColor = Color(0xFFA8E6CF);
  static const Color secondaryColor = Color(0xFF6CC9A8);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFF3FBF7);
  static const Color textPrimary = Color(0xFF133429);
  static const Color textSecondary = Color(0xFF5D7C71);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Theme Data ────────────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: surfaceColor,
          onSurface: textPrimary,
        ),
        scaffoldBackgroundColor: backgroundColor,

        // Bottom navigation bar
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surfaceColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          indicatorColor: primaryColor.withValues(alpha: 0.2),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF2E7D66));
            }
            return const IconThemeData(color: textSecondary);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: Color(0xFF2E7D66),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              );
            }
            return const TextStyle(color: textSecondary, fontSize: 12);
          }),
        ),

        // App bar
        appBarTheme: const AppBarTheme(
          backgroundColor: surfaceColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF2E7D66),
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          iconTheme: IconThemeData(color: textPrimary),
        ),

        // Tab bar
        tabBarTheme: const TabBarThemeData(
          dividerColor: Colors.transparent,
          indicatorColor: Color(0xFF2E7D66),
          labelColor: Color(0xFF2E7D66),
          unselectedLabelColor: textSecondary,
          labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          unselectedLabelStyle:
              TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
        ),

        // Cards
        cardTheme: CardThemeData(
          color: cardColor,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),

        // Input / Search field
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF2E7D66), width: 1.5),
          ),
          hintStyle: const TextStyle(color: textSecondary),
          prefixIconColor: textSecondary,
        ),

        // Snack bars
        snackBarTheme: SnackBarThemeData(
          backgroundColor: cardColor,
          contentTextStyle: const TextStyle(color: textPrimary),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
}
