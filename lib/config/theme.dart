import 'package:flutter/material.dart';

/// GetMyBus Mobility Design System Tokens
/// Inspired by Google Maps, Uber, Linear, and modern transit engineering.
/// Restrained, calm, minimal, and highly usable.
class AppColors {
  // ── Primary Brand Palette (Restrained Royal Blue) ──
  static const Color primary = Color(0xFF1D4ED8);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color primaryGlow = Color(0x1A1D4ED8); // 10% opacity

  // ── Telematics Accent (Restrained Emerald / Teal for Live Data) ──
  static const Color accent = Color(0xFF0D9488); // Telemetry Teal
  static const Color accentDark = Color(0xFF0F766E);
  static const Color accentLight = Color(0xFFF0FDFA);
  static const Color accentGlow = Color(0x1A0D9488);

  // ── Architectural Neutrals (Off-Black, Crisp Slate, White) ──
  static const Color uberBlack = Color(0xFF0F172A); // Slate 900
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color cardDark = Color(0xFF1E293B); // Slate 800

  // ── Surfaces & Borders ──
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceSecondary = Color(0xFFF1F5F9); // Slate 100
  static const Color border = Color(0xFFE2E8F0); // Slate 200 hairline
  static const Color borderLight = Color(0xFFF1F5F9);

  // ── Precise Typography Colors ──
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF64748B); // Slate 500
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Transit Status Signals ──
  static const Color statusLive = Color(0xFF10B981); // Emerald 500
  static const Color statusLiveGlow = Color(0x1A10B981);
  static const Color statusWarning = Color(0xFFF59E0B); // Amber 500
  static const Color statusWarningGlow = Color(0x1AF59E0B);
  static const Color statusError = Color(0xFFEF4444); // Red 500
  static const Color statusErrorGlow = Color(0x1AEF4444);
  static const Color statusExpress = Color(0xFF4F46E5); // Indigo 600

  // ── Linear Fills ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF1E40AF)],
  );

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
  );

  static const LinearGradient cardOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Color(0xFFF8FAFC)],
  );
}

/// Unified Theme Data for GetMyBus
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        error: AppColors.statusError,
        onError: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.uberBlack,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
    );
  }
}
