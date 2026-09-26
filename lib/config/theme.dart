import 'package:flutter/material.dart';

/// GetMyBus Official Brand Colors & Design System
/// Derived from getmybus.in brand guidelines and official logos.
class AppColors {
  // ── Primary Brand Palette (from GetMyBusApp.jsx) ──
  static const Color primary = Color(0xFF2B57FF);
  static const Color primaryDark = Color(0xFF1E3FCC);
  static const Color primaryLight = Color(0xFFEEF2FF);
  static const Color primaryGlow = Color(0x262B57FF); // 15% opacity

  // ── Brand Accent / Telematics Cyan ──
  static const Color accent = Color(0xFF12CBE0);
  static const Color accentDark = Color(0xFF0891B2);
  static const Color accentLight = Color(0xFFCFFAFE);
  static const Color accentGlow = Color(0x3312CBE0);

  // ── Uber Contrast Neutrals (Dark) ──
  static const Color uberBlack = Color(0xFF0A0D14);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1E293B);

  // ── Clean Surfaces (from GetMyBusApp (1).jsx v2) ──
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFBFD);
  static const Color bg = Color(0xFFFAFBFD);
  static const Color surfaceSecondary = Color(0xFFF1F3F8);
  static const Color inputBg = Color(0xFFF1F3F8);
  static const Color border = Color(0xFFEEF0F4);
  static const Color borderLight = Color(0xFFEEF0F4);
  static const Color line = Color(0xFFEEF0F4);
  static const Color lineDivider = Color(0xFFE2E5EC);
  static const Color tint = Color(0xFFEEF2FF);

  // ── Typography Colors (from GetMyBusApp (1).jsx v2) ──
  static const Color ink = Color(0xFF12141C);
  static const Color textPrimary = Color(0xFF12141C);
  static const Color sub = Color(0xFF6B7280);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color faint = Color(0xFF9AA2B1);
  static const Color textMuted = Color(0xFF9AA2B1);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Transit Status Accents (from GetMyBusApp (1).jsx v2) ──
  static const Color success = Color(0xFF17B26A);
  static const Color successBg = Color(0xFFEAF9F1);
  static const Color statusLive = Color(0xFF17B26A);
  static const Color statusLiveBg = Color(0xFFEAF9F1);
  static const Color statusLiveGlow = Color(0x2617B26A);

  static const Color orange = Color(0xFFFF9F45);
  static const Color orangeBg = Color(0xFFFFF4E8);
  static const Color statusWarning = Color(0xFFFF9F45);
  static const Color statusWarningGlow = Color(0x26FF9F45);

  static const Color danger = Color(0xFFE4483C);
  static const Color dangerBg = Color(0xFFFDECEA);
  static const Color statusError = Color(0xFFE4483C);
  static const Color statusErrorGlow = Color(0x26E4483C);

  /// Highway Corridor Special / Express
  static const Color statusExpress = Color(0xFF6366F1);

  // ── Extended Colors from GetMyBusApp_v3 (2).jsx ──
  static const Color cyan = Color(0xFF12CBE0);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color whatsappGreen = Color(0xFF25D366);

  /// Fixed per-route accent colors — like a metro map, each route number
  /// always reads in the same color everywhere it appears.
  static const Map<String, Color> routeColors = {
    '42': primary,
    '7B': cyan,
    '12': violet,
  };

  static Color getRouteColor(String routeNum) {
    return routeColors[routeNum] ?? primary;
  }

  // ── Gradient Definitions (from GetMyBusApp.jsx) ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2B57FF), Color(0xFF1E3FCC)],
  );

  // ── GetMyBus Brand Tokens & Pass Gradients ──
  /// Electric Royal Blue Primary (from GetMyBusApp.jsx)
  static const Color brandBlue = Color(0xFF2B57FF);
  static const Color brandBlueDark = Color(0xFF1E3FCC);
  static const Color brandBlueLight = Color(0xFFEEF2FF);

  /// Telematics Cyan Accent
  static const Color brandCyan = Color(0xFF12CBE0);
  static const Color brandCyanDark = Color(0xFF0891B2);
  static const Color brandCyanLight = Color(0xFFCFFAFE);

  /// Deep Navy Obsidian (for Pass backdrop and dark surfaces)
  static const Color obsidianDark = Color(0xFF0A0F1D);

  /// GetMyBus Primary Brand Gradient (from GetMyBusApp.jsx: 135deg, #2B57FF, #1E3FCC)
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2B57FF), Color(0xFF1E3FCC)],
  );

  /// Smart Card Pass Gradient
  static const LinearGradient passCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF0284C7), Color(0xFF06B6D4)],
  );

  /// Button CTA Gradient (Vibrant Royal Blue to Vivid Cyan)
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
  );

  /// Legacy aliases mapped to official brand colors
  static const Color purplePrimary = Color(0xFF2563EB);
  static const Color purpleDark = Color(0xFF1D4ED8);
  static const Color purpleLight = Color(0xFFEFF6FF);
  static const Color neonPink = Color(0xFF06B6D4);
  static const LinearGradient purplePinkGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
  );

  static const LinearGradient orangePurpleGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
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
          side: BorderSide.none,
        ),
      ),
    );
  }
}
