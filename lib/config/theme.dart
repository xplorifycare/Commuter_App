import 'package:flutter/material.dart';

/// Standardized Corner-Radius Scale from GetMyBusApp_v4.jsx
class AppRadius {
  static const double chip = 8.0;
  static const double card = 14.0;
  static const double sheet = 20.0;
  static const double frame = 28.0;
}

/// Unified Theme Token Set for GetMyBus (Light & Dark)
class AppThemeTokens {
  final Color primary;
  final Color primaryDark;
  final Color cyan;
  final Color violet;
  final Color orange;
  final Color warm;
  final Color bg;
  final Color surface;
  final Color ink;
  final Color sub;
  final Color faint;
  final Color line;
  final Color tint;
  final Color success;
  final Color successBg;
  final Color danger;
  final bool isDark;

  const AppThemeTokens({
    required this.primary,
    required this.primaryDark,
    required this.cyan,
    required this.violet,
    required this.orange,
    required this.warm,
    required this.bg,
    required this.surface,
    required this.ink,
    required this.sub,
    required this.faint,
    required this.line,
    required this.tint,
    required this.success,
    required this.successBg,
    required this.danger,
    required this.isDark,
  });

  Color getRouteColor(String routeNum) {
    if (routeNum == '42') return primary;
    if (routeNum == '7B') return cyan;
    if (routeNum == '12') return violet;
    return primary;
  }

  static const AppThemeTokens light = AppThemeTokens(
    primary: Color(0xFF2B57FF),
    primaryDark: Color(0xFF1E3FCC),
    cyan: Color(0xFF12CBE0),
    violet: Color(0xFF8B5CF6),
    orange: Color(0xFFFF9F45),
    warm: Color(0xFFC17A54),
    bg: Color(0xFFFAFBFD),
    surface: Color(0xFFFFFFFF),
    ink: Color(0xFF12141C),
    sub: Color(0xFF6B7280),
    faint: Color(0xFF9AA2B1),
    line: Color(0xFFEEF0F4),
    tint: Color(0xFFEEF2FF),
    success: Color(0xFF17B26A),
    successBg: Color(0xFFEAF9F1),
    danger: Color(0xFFE4483C),
    isDark: false,
  );

  static const AppThemeTokens dark = AppThemeTokens(
    primary: Color(0xFF6C8CFF),
    primaryDark: Color(0xFF98ABFF),
    cyan: Color(0xFF4FE1EF),
    violet: Color(0xFFB29CFF),
    orange: Color(0xFFFFB870),
    warm: Color(0xFFE0A57C),
    bg: Color(0xFF0D0F14),
    surface: Color(0xFF15181F),
    ink: Color(0xFFF3F4F7),
    sub: Color(0xFFA0A6B3),
    faint: Color(0xFF6E7484),
    line: Color(0xFF242833),
    tint: Color(0xFF1C2130),
    success: Color(0xFF3FD98A),
    successBg: Color(0xFF123024),
    danger: Color(0xFFFF6E64),
    isDark: true,
  );

  static AppThemeTokens of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}

/// GetMyBus Official Brand Colors & Design System
/// Derived from getmybus.in brand guidelines and official logos.
class AppColors {
  // ── Primary Brand Palette (Light) ──
  static const Color primary = Color(0xFF2B57FF);
  static const Color primaryDark = Color(0xFF1E3FCC);
  static const Color primaryLight = Color(0xFFEEF2FF);
  static const Color primaryGlow = Color(0x262B57FF); // 15% opacity

  // Legacy Aliases
  static const Color brandBlue = primary;
  static const Color brandBlueDark = primaryDark;
  static const Color brandBlueLight = primaryLight;

  // ── Brand Accent / Telematics Cyan ──
  static const Color accent = Color(0xFF12CBE0);
  static const Color accentDark = Color(0xFF0891B2);
  static const Color accentLight = Color(0xFFCFFAFE);
  static const Color accentGlow = Color(0x3312CBE0);

  // Legacy Aliases
  static const Color brandCyan = accent;
  static const Color brandCyanDark = accentDark;
  static const Color brandCyanLight = accentLight;

  // ── Uber Contrast Neutrals (Dark) ──
  static const Color uberBlack = Color(0xFF0A0D14);
  static const Color obsidianDark = Color(0xFF0A0F1D);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1E293B);

  // ── Clean Surfaces ──
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

  // ── Typography Colors ──
  static const Color ink = Color(0xFF12141C);
  static const Color textPrimary = Color(0xFF12141C);
  static const Color sub = Color(0xFF6B7280);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color faint = Color(0xFF9AA2B1);
  static const Color textMuted = Color(0xFF9AA2B1);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Transit Status Accents ──
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

  // ── Extended Colors from v3 & v4 ──
  static const Color cyan = Color(0xFF12CBE0);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color warm = Color(0xFFC17A54);
  static const Color warmDark = Color(0xFFA65E3D);

  // ── v4 Purpose-Built Dark Palette ──
  static const Color darkPrimary = Color(0xFF6C8CFF);
  static const Color darkPrimaryDark = Color(0xFF98ABFF);
  static const Color darkCyan = Color(0xFF4FE1EF);
  static const Color darkViolet = Color(0xFFB29CFF);
  static const Color darkOrange = Color(0xFFFFB870);
  static const Color darkWarm = Color(0xFFE0A57C);
  static const Color darkBg = Color(0xFF0D0F14);
  static const Color darkSurface = Color(0xFF15181F);
  static const Color darkInk = Color(0xFFF3F4F7);
  static const Color darkSub = Color(0xFFA0A6B3);
  static const Color darkFaint = Color(0xFF6E7484);
  static const Color darkLine = Color(0xFF242833);
  static const Color darkTint = Color(0xFF1C2130);
  static const Color darkSuccess = Color(0xFF3FD98A);
  static const Color darkSuccessBg = Color(0xFF123024);
  static const Color darkDanger = Color(0xFFFF6E64);

  /// Fixed per-route accent colors
  static const Map<String, Color> routeColors = {
    '42': primary,
    '7B': cyan,
    '12': violet,
  };

  static Color getRouteColor(String routeNum) {
    return routeColors[routeNum] ?? primary;
  }

  // ── Gradient Definitions ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2B57FF), Color(0xFF1E3FCC)],
  );

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2B57FF), Color(0xFF1E3FCC)],
  );

  static const LinearGradient milestoneGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC17A54), Color(0xFFA65E3D)],
  );

  static const LinearGradient passCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF0284C7), Color(0xFF06B6D4)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
  );

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

/// Unified Theme Data for GetMyBus (Material 3)
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
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
            borderRadius: BorderRadius.circular(AppRadius.card),
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
          borderRadius: BorderRadius.circular(AppRadius.sheet),
          side: BorderSide.none,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        onPrimary: Color(0xFF0D0F14),
        secondary: AppColors.darkCyan,
        onSecondary: Color(0xFF0D0F14),
        error: AppColors.darkDanger,
        onError: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkInk,
      ),
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.darkInk),
        titleTextStyle: TextStyle(
          color: AppColors.darkInk,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkInk,
          foregroundColor: AppColors.darkBg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sheet),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
