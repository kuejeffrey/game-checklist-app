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

  static bool get isInitialized => _isInitialized;
  static SupabaseClient get client => Supabase.instance.client;
  static Session? get currentSession =>
      _isInitialized ? client.auth.currentSession : null;
  static User? get currentUser => _isInitialized ? client.auth.currentUser : null;
  static Stream<AuthState> get authStateChanges =>
      _isInitialized ? client.auth.onAuthStateChange : Stream<AuthState>.empty();

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _ensureInitialized();
    await client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    await _upsertCurrentProfile();
  }

  static Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _ensureInitialized();
    final trimmedName = name.trim();
    final response = await client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'display_name': trimmedName,
        'name': trimmedName,
      },
    );

    if (response.session != null) {
      await _upsertCurrentProfile();
      return;
    }

    throw Exception(
      'Email confirmation is still enabled in Supabase. Disable email confirmation for now so signup can go straight into the app.',
    );
  }

  static Future<void> signOut() async {
    _ensureInitialized();
    await client.auth.signOut();
  }

  static Future<void> _upsertCurrentProfile() async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    final metadata = user.userMetadata;
    final rawName = metadata?['display_name'] ?? metadata?['name'];
    final displayName = rawName?.toString().trim();

    try {
      await client.from('profiles').upsert(
        {
          'id': user.id,
          'email': user.email,
          if (displayName != null && displayName.isNotEmpty)
            'display_name': displayName,
        },
        onConflict: 'id',
      );
    } on PostgrestException catch (error) {
      final message = error.message.toLowerCase();
      if (message.contains('profiles') && message.contains('does not exist')) {
        return;
      }

      rethrow;
    }
  }

  static void _ensureInitialized() {
    if (_isInitialized) {
      return;
    }

    throw Exception(
      'Supabase is not available right now. Check your project settings and try again.',
    );
  }
}
