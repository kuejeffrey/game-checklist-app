import 'package:flutter/material.dart';

import '../services/supabase_service.dart';
import '../theme/level_up_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final nextRoute = SupabaseService.isInitialized &&
                SupabaseService.currentSession == null
            ? '/auth'
            : '/app';
        Navigator.pushReplacementNamed(context, nextRoute);
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
      backgroundColor: LevelUpTheme.cream,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: _SplashOrb(
              size: 260,
              color: LevelUpTheme.sage.withOpacity(0.12),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: _SplashOrb(
              size: 240,
              color: LevelUpTheme.peach.withOpacity(0.16),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      gradient: LevelUpTheme.authHeroGradient,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: LevelUpTheme.elevatedShadow,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 46,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Level Up',
                    style: TextStyle(
                      color: LevelUpTheme.charcoal,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'One step at a time',
                    style: TextStyle(
                      color: LevelUpTheme.mutedForeground,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 48),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: LevelUpTheme.sage,
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashOrb extends StatelessWidget {
  const _SplashOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
