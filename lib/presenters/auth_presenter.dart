import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

class AuthPresenter extends ChangeNotifier {
  AuthPresenter() {
    _session = SupabaseService.currentSession;
    _subscription = SupabaseService.authStateChanges.listen((authState) {
      _session = authState.session;
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _subscription;
  Session? _session;
  bool _isSigningOut = false;

  bool get isSignedIn => _session != null;
  bool get isSigningOut => _isSigningOut;
  User? get user => _session?.user;
  String? get email => user?.email;

  String? get displayName {
    final metadata = user?.userMetadata;
    final rawName = metadata?['display_name'] ?? metadata?['name'];
    final trimmedName = rawName?.toString().trim();

    if (trimmedName != null && trimmedName.isNotEmpty) {
      return trimmedName;
    }

    final currentEmail = email;
    if (currentEmail == null || currentEmail.isEmpty) {
      return null;
    }

    return currentEmail.split('@').first;
  }

  Future<void> signOut() async {
    if (_isSigningOut) {
      return;
    }

    _isSigningOut = true;
    notifyListeners();

    try {
      await SupabaseService.signOut();
    } finally {
      _isSigningOut = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
