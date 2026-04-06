import 'package:flutter/material.dart';

class LevelUpTheme {
  static const Color cream = Color(0xFFFAF7F0);
  static const Color charcoal = Color(0xFF2C2C2E);
  static const Color sage = Color(0xFF7B9B8F);
  static const Color peach = Color(0xFFE8AE9A);
  static const Color gold = Color(0xFFD4A574);
  static const Color dustyBlue = Color(0xFF8DA8C4);
  static const Color muted = Color(0xFFF4F1E8);
  static const Color mutedForeground = Color(0xFF6B6B6D);
  static const Color success = Color(0xFF7BA37E);
  static const Color destructive = Color(0xFFD4183D);
  static const Color border = Color(0x1F2C2C2E);

  static LinearGradient get authHeroGradient => const LinearGradient(
        colors: <Color>[sage, peach],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get splashGradient => const LinearGradient(
        colors: <Color>[sage, dustyBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get progressGradient => LinearGradient(
        colors: <Color>[
          sage.withOpacity(0.14),
          peach.withOpacity(0.14),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get rewardsGradient => LinearGradient(
        colors: <Color>[
          gold.withOpacity(0.16),
          peach.withOpacity(0.14),
          sage.withOpacity(0.12),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static List<BoxShadow> get cardShadow => <BoxShadow>[
        BoxShadow(
          color: charcoal.withOpacity(0.08),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => <BoxShadow>[
        BoxShadow(
          color: charcoal.withOpacity(0.12),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  static ThemeData buildTheme() {
    const colorScheme = ColorScheme.light(
      primary: sage,
      onPrimary: Colors.white,
      secondary: peach,
      onSecondary: charcoal,
      surface: Colors.white,
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
      splashColor: sage.withOpacity(0.08),
      highlightColor: sage.withOpacity(0.05),
      dividerColor: border,
      fontFamily: 'Nunito',
      textTheme: baseTextTheme.copyWith(
        headlineSmall: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: charcoal,
          height: 1.1,
        ),
        titleLarge: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: charcoal,
        ),
        titleMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: charcoal,
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
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
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
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: sage, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: destructive, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: sage,
          foregroundColor: Colors.white,
          disabledBackgroundColor: sage.withOpacity(0.4),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: charcoal,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
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
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
