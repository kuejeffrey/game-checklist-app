import 'package:flutter/material.dart';

import '../presenters/app_shell_presenter.dart';
import '../presenters/home_presenter.dart';
import '../presenters/rewards_presenter.dart';
import '../presenters/settings_presenter.dart';
import '../services/affirmation_notification_service.dart';
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
  late final HomePresenter _homePresenter;
  late final RewardsPresenter _rewardsPresenter;
  late final SettingsPresenter _settingsPresenter;
  late final AffirmationNotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _shellPresenter = AppShellPresenter();
    _homePresenter = HomePresenter();
    _rewardsPresenter = RewardsPresenter();
    _notificationService = AffirmationNotificationService();
    _settingsPresenter = SettingsPresenter(
      versionLabel: '1.0.2 (MVP)',
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
    _shellPresenter.dispose();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shellPresenter,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(
            index: _shellPresenter.selectedIndex,
            children: [
              HomeScreen(presenter: _homePresenter),
              RewardsScreen(presenter: _rewardsPresenter),
              SettingsScreen(
                presenter: _settingsPresenter,
                onResetAll: _handleResetAll,
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _shellPresenter.selectedIndex,
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFFEDE8F5),
            onDestinationSelected: _shellPresenter.selectTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.star_outline),
                selectedIcon: Icon(Icons.star),
                label: 'Rewards',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
