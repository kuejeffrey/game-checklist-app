import 'package:flutter/material.dart';

class LevelUpTheme {
  // Base
  static const Color cream = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color charcoal = Color(0xFF0F172A);

  // Accents — more saturated for a modern, vivid feel
  static const Color sage = Color(0xFF3D8B78);
  static const Color peach = Color(0xFFE8836A);
  static const Color gold = Color(0xFFC08A30);
  static const Color dustyBlue = Color(0xFF4A88BE);

  // Neutrals
  static const Color muted = Color(0xFFF1F5F9);
  static const Color mutedForeground = Color(0xFF64748B);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color destructive = Color(0xFFEF4444);

  // Border — very subtle (6% opacity on charcoal)
  static const Color border = Color(0x0F0F172A);

  // ── Gradients ──────────────────────────────────────────────────────────────

  static LinearGradient get authHeroGradient => const LinearGradient(
        colors: <Color>[sage, dustyBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get splashGradient => const LinearGradient(
        colors: <Color>[sage, dustyBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get progressBarGradient => const LinearGradient(
        colors: <Color>[sage, dustyBlue],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  static LinearGradient get rewardsProgressGradient => const LinearGradient(
        colors: <Color>[gold, peach],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  static LinearGradient get progressGradient => LinearGradient(
        colors: <Color>[
          sage.withOpacity(0.08),
          dustyBlue.withOpacity(0.06),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get rewardsGradient => LinearGradient(
        colors: <Color>[
          gold.withOpacity(0.12),
          peach.withOpacity(0.10),
          sage.withOpacity(0.08),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // ── Shadows ─────────────────────────────────────────────────────────────────

  /// Two-layer shadow: tight edge definition + wide soft lift
  static List<BoxShadow> get cardShadow => const <BoxShadow>[
        BoxShadow(
          color: Color(0x050F172A),
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
        BoxShadow(
          color: Color(0x0A0F172A),
          blurRadius: 24,
          spreadRadius: -4,
          offset: Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => const <BoxShadow>[
        BoxShadow(
          color: Color(0x08000000),
          blurRadius: 2,
          offset: Offset(0, 2),
        ),
        BoxShadow(
          color: Color(0x180F172A),
          blurRadius: 48,
          spreadRadius: -8,
          offset: Offset(0, 20),
        ),
      ];

  // ── Theme ───────────────────────────────────────────────────────────────────

  static ThemeData buildTheme() {
    const colorScheme = ColorScheme.light(
      primary: sage,
      onPrimary: Colors.white,
      secondary: peach,
      onSecondary: Colors.white,
      surface: surface,
      onSurface: charcoal,
      error: destructive,
      onError: Colors.white,
      outline: border,
    );

    final baseTextTheme = ThemeData.light(useMaterial3: true).textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: cream,
      canvasColor: cream,
      splashColor: sage.withOpacity(0.06),
      highlightColor: sage.withOpacity(0.04),
      dividerColor: border,
      fontFamily: 'Nunito',
      textTheme: baseTextTheme.copyWith(
        headlineSmall: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: charcoal,
          height: 1.1,
          letterSpacing: -0.5,
        ),
        titleLarge: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: charcoal,
          letterSpacing: -0.3,
        ),
        titleMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: charcoal,
          letterSpacing: -0.2,
        ),
        bodyLarge: const TextStyle(
          fontSize: 15,
          color: charcoal,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: charcoal,
          height: 1.5,
        ),
        bodySmall: const TextStyle(
          fontSize: 13,
          color: mutedForeground,
          height: 1.45,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        foregroundColor: charcoal,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: muted,
        hintStyle: const TextStyle(
          color: mutedForeground,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: mutedForeground,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        prefixIconColor: mutedForeground,
        suffixIconColor: mutedForeground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: sage, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: destructive, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: sage,
          foregroundColor: Colors.white,
          disabledBackgroundColor: sage.withOpacity(0.35),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: charcoal,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: sage,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: charcoal,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
