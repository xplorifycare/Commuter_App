import 'package:flutter/material.dart';

/// GetMyBus Official Brand Colors & Design System
/// Derived from getmybus.in brand guidelines and official logos.
class AppColors {
  // ── Primary Brand Palette ──
  /// GetMyBus Signature Royal Blue (From official logo & website branding)
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFFDBEAFE);
  static const Color primaryGlow = Color(0x262563EB); // 15% opacity

  // ── Brand Accent / Telematics Cyan ──
  /// Electric Cyan / Aqua (Represents real-time 4s GPS telemetry and digital connectivity)
  static const Color accent = Color(0xFF06B6D4);
  static const Color accentDark = Color(0xFF0891B2);
  static const Color accentLight = Color(0xFFCFFAFE);
  static const Color accentGlow = Color(0x3306B6D4); // 20% opacity

  // ── Uber Contrast Neutrals (Dark) ──
  static const Color uberBlack = Color(0xFF0A0D14);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1E293B);

  // ── Uber Clean Surfaces (Light) ──
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surfaceSecondary = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // ── Typography Colors ──
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Transit Status Accents ──
  /// Live on-time status / seats available
  static const Color statusLive = Color(0xFF10B981);
  static const Color statusLiveGlow = Color(0x2610B981);

  /// Walking nudge / bus approaching / few seats
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusWarningGlow = Color(0x26F59E0B);

  /// Delay / heavy crowd / full
  static const Color statusError = Color(0xFFEF4444);
  static const Color statusErrorGlow = Color(0x26EF4444);

  /// Highway Corridor Special / Express
  static const Color statusExpress = Color(0xFF6366F1);

  // ── Gradient Definitions ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF1D4ED8)],
  );

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, accent],
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
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
    );
  }
}
