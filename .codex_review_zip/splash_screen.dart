// ============================================================
// screens/splash_screen.dart — Launch / Splash Screen
//
// This is the first screen the user sees when the app opens.
// It shows the app logo and name for 2 seconds, then
// navigates automatically to the Home screen.
// ============================================================

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  // Animation controller for the fade-in effect
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Set up a simple fade-in animation over 800ms
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    // After 2.5 seconds, navigate to the Home screen
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warm background color matching the app theme
      backgroundColor: const Color(0xFF7C6EAF),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── App Icon Placeholder ─────────────────────
              // Replace this Container with an actual pixel-art
              // image later: Image.asset('assets/icon.png')
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '⚔️',
                    style: TextStyle(fontSize: 48),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── App Name ─────────────────────────────────
              const Text(
                'Level Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 8),

              // ── Tagline ───────────────────────────────────
              Text(
                'One step at a time',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 60),

              // ── Loading Indicator ─────────────────────────
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white.withOpacity(0.7),
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
