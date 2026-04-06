import 'package:flutter/material.dart';

import 'screens/app_shell_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'services/supabase_service.dart';
import 'theme/level_up_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SupabaseService.initialize();
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'supabase',
        context: ErrorDescription('while initializing Supabase'),
      ),
    );
  }

  runApp(const LevelUpApp());
}

class LevelUpApp extends StatelessWidget {
  const LevelUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Level Up',
      debugShowCheckedModeBanner: false,
      theme: LevelUpTheme.buildTheme(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/auth': (context) => const AuthScreen(),
        '/app': (context) => const AppShellScreen(),
        '/home': (context) => const AppShellScreen(),
      },
    );
  }
}
