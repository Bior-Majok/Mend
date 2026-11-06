import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF1B4332);
  static const Color primaryGradientStart = Color(0xFF2D6A4F);
  static const Color primaryGradientEnd = Color(0xFF1B4332);
  static const Color secondaryColor = Color(0xFF40916C);
  static const Color darkForest = Color(0xFF0F2B1F);

  // Surface and background
  static const Color backgroundColor = Color(0xFFF3F6F4);
  static const Color cardColor = Colors.white;
  static const Color lightGreenSurface = Color(0xFFE8F2EC);
  static const Color mintAccent = Color(0xFFD8EBE0);

  // Status colors
  static const Color statusSubmittedColor = Color(0xFF1B4332);
  static const Color statusSubmittedBg = Color(0xFFE2EFE7);

  static const Color statusInProgressColor = Color(0xFFB45309);
  static const Color statusInProgressBg = Color(0xFFFEF3C7);

  static const Color statusResolvedColor = Color(0xFF15803D);
  static const Color statusResolvedBg = Color(0xFFDCFCE7);

  // Metric backgrounds
  static const Color metricForestBg = Color(0xFFE2EFE7);
  static const Color metricAmberBg = Color(0xFFFEF3C7);
  static const Color metricGreenBg = Color(0xFFDCFCE7);
  static const Color metricSageBg = Color(0xFFE8F2EC);

  // Text colors
  static const Color textPrimary = Color(0xFF14291E);
  static const Color textSecondary = Color(0xFF4B6355);
  static const Color textMuted = Color(0xFF869E90);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
        surfaceContainerLowest: backgroundColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFDCE7DF), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD4E2D8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD4E2D8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      ),
    );
  }
}
