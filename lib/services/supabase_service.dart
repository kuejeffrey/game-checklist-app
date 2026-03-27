import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String projectUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://bjkgpkcptiyqmrpbtpoa.supabase.co',
  );
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_6CV_RKOJBRDUW4ZlInBjnA_0Wt-0pRc',
  );

  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    await Supabase.initialize(
      url: projectUrl,
      anonKey: publishableKey,
    );

    _isInitialized = true;
  }

  static SupabaseClient get client => Supabase.instance.client;
}
