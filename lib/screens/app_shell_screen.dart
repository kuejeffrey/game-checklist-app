import 'package:flutter/material.dart';

import '../presenters/app_shell_presenter.dart';
import '../presenters/auth_presenter.dart';
import '../presenters/home_presenter.dart';
import '../presenters/rewards_presenter.dart';
import '../presenters/settings_presenter.dart';
import '../services/affirmation_notification_service.dart';
import '../services/supabase_service.dart';
import '../theme/level_up_theme.dart';
import '../widgets/level_up_bottom_nav.dart';
import 'home_screen.dart';
import 'rewards_screen.dart';
import 'settings_screen.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  late final AppShellPresenter _shellPresenter;
  late final AuthPresenter _authPresenter;
  late final HomePresenter _homePresenter;
  late final RewardsPresenter _rewardsPresenter;
  late final SettingsPresenter _settingsPresenter;
  late final AffirmationNotificationService _notificationService;
  bool _isReloadingAccountData = false;
  String? _lastAuthUserId;

  @override
  void initState() {
    super.initState();
    _shellPresenter = AppShellPresenter();
    _authPresenter = AuthPresenter();
    _lastAuthUserId = _authPresenter.user?.id;
    _authPresenter.addListener(_handleAuthStateChanged);
    _homePresenter = HomePresenter();
    _rewardsPresenter = RewardsPresenter();
    _notificationService = AffirmationNotificationService();
    _settingsPresenter = SettingsPresenter(
      versionLabel: '2.1.0',
      notificationService: _notificationService,
    );

    _rewardsPresenter.initialize();
    _settingsPresenter.initialize();
    _homePresenter.addListener(_syncRewards);
    _homePresenter.loadData();
  }

  @override
  void dispose() {
    _homePresenter.removeListener(_syncRewards);
    _authPresenter.removeListener(_handleAuthStateChanged);
    _shellPresenter.dispose();
    _authPresenter.dispose();
    _homePresenter.dispose();
    _rewardsPresenter.dispose();
    _settingsPresenter.dispose();
    super.dispose();
  }

  Future<void> _handleResetAll() async {
    await _homePresenter.resetAllData();
    await _settingsPresenter.resetAfterDataClear();
    _shellPresenter.selectTab(0);
  }

  void _syncRewards() {
    _rewardsPresenter.updateTotalXp(_homePresenter.totalXp);
  }

  void _handleAuthStateChanged() {
    final currentUserId = _authPresenter.user?.id;
    if (currentUserId == _lastAuthUserId) {
      return;
    }

    final previousUserId = _lastAuthUserId;
    _lastAuthUserId = currentUserId;

    if (currentUserId == null && previousUserId != null) {
      _goToAuthScreen();
      return;
    }

    _reloadForCurrentAccount();
  }

  Future<void> _reloadForCurrentAccount() async {
    if (_isReloadingAccountData) {
      return;
    }

    _isReloadingAccountData = true;
    try {
      await _settingsPresenter.initialize();
      await _homePresenter.loadData();
      await _rewardsPresenter.reloadForCurrentUser(_homePresenter.totalXp);
    } finally {
      _isReloadingAccountData = false;
    }
  }

  void _goToAuthScreen() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
  }

  Future<void> _openAccountScreen() async {
    if (!mounted) {
      return;
    }

    if (!SupabaseService.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account login is not available right now.'),
        ),
      );
      return;
    }

    _goToAuthScreen();
  }

  Future<void> _handleSignOut() async {
    try {
      await _authPresenter.signOut();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_shellPresenter, _authPresenter]),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: LevelUpTheme.cream,
          extendBody: true,
          body: IndexedStack(
            index: _shellPresenter.selectedIndex,
            children: [
              HomeScreen(
                presenter: _homePresenter,
                userName: _authPresenter.displayName,
              ),
              RewardsScreen(presenter: _rewardsPresenter),
              SettingsScreen(
                presenter: _settingsPresenter,
                authPresenter: _authPresenter,
                onResetAll: _handleResetAll,
                onOpenAccountScreen: _openAccountScreen,
                onSignOut: _handleSignOut,
              ),
            ],
          ),
          bottomNavigationBar: LevelUpBottomNav(
            selectedIndex: _shellPresenter.selectedIndex,
            onDestinationSelected: _shellPresenter.selectTab,
          ),
        );
      },
    );
  }
}
