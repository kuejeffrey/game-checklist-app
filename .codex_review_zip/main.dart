// ============================================================
// main.dart — App Entry Point
// This is the first file Flutter runs when the app launches.
// It sets up the theme, fonts, and navigation routes.
// ============================================================

import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/rewards_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  // Ensure Flutter is initialized before we do anything with storage
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LevelUpApp());
}

class LevelUpApp extends StatelessWidget {
  const LevelUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Level Up',
      debugShowCheckedModeBanner: false,

      // ── App-wide Theme ─────────────────────────────────────
      // All colors and fonts are defined here so you only need
      // to change them in one place to restyle the whole app.
      theme: ThemeData(
        useMaterial3: true,

        // Soft lavender-cream color scheme — cozy, not clinical
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C6EAF), // soft purple
          brightness: Brightness.light,
          background: const Color(0xFFFAF8F5), // warm off-white
          surface: const Color(0xFFFFFFFF),
          primary: const Color(0xFF7C6EAF),    // lavender
          secondary: const Color(0xFF9FC5A0),  // sage green
          tertiary: const Color(0xFFE8A87C),   // warm peach
        ),

        // Google Fonts can be added via pubspec.yaml later
        // For now we use the system font stack
        fontFamily: 'Nunito', // fallback to system sans-serif

        scaffoldBackgroundColor: const Color(0xFFFAF8F5),

        // Card styling — soft rounded corners
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
      ),

      // ── Navigation Routes ──────────────────────────────────
      // Each route name maps to a screen widget.
      // Use Navigator.pushNamed(context, '/home') to navigate.
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home':   (context) => const HomeScreen(),
        '/rewards':(context) => const RewardsScreen(),
        '/settings':(context) => const SettingsScreen(),
      },
    );
  }
}
