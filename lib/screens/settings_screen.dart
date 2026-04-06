import 'package:flutter/material.dart';

import '../presenters/auth_presenter.dart';
import '../presenters/settings_presenter.dart';
import '../theme/level_up_theme.dart';
import '../widgets/level_up_action_tile.dart';
import '../widgets/level_up_card.dart';
import '../widgets/level_up_section_label.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.presenter,
    required this.authPresenter,
    required this.onResetAll,
    required this.onOpenAccountScreen,
    required this.onSignOut,
  });

  final SettingsPresenter presenter;
  final AuthPresenter authPresenter;
  final Future<void> Function() onResetAll;
  final Future<void> Function() onOpenAccountScreen;
  final Future<void> Function() onSignOut;

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Fresh start?'),
        content: const Text(
          'This will clear all your tasks, XP, streak, and today\'s check-in. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep going'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: LevelUpTheme.destructive,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset everything'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await onResetAll();
    }
  }

  Future<void> _pickAffirmationTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: presenter.affirmationTime,
    );

    if (picked != null) {
      await presenter.setAffirmationTime(picked);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'Your local task data stays on this device, but this account will be disconnected until you log in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Stay signed in'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await onSignOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([presenter, authPresenter]),
      builder: (context, _) {
        return ColoredBox(
          color: LevelUpTheme.cream,
          child: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 120),
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: LevelUpTheme.charcoal,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'A calm place to manage your account, reminders, and app details.',
                  style: TextStyle(
                    fontSize: 14,
                    color: LevelUpTheme.mutedForeground,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 26),
                const LevelUpSectionLabel('Account'),
                const SizedBox(height: 10),
                _buildSettingsCard(
                  children: [
                    if (authPresenter.isSignedIn) ...[
                      LevelUpActionTile(
                        icon: Icons.person_outline_rounded,
                        title: authPresenter.displayName ?? 'Signed in',
                        subtitle:
                            authPresenter.email ?? 'Connected through Supabase',
                        showChevron: false,
                      ),
                      const Divider(height: 1),
                      LevelUpActionTile(
                        icon: Icons.logout_rounded,
                        title: authPresenter.isSigningOut
                            ? 'Signing out...'
                            : 'Sign out',
                        subtitle:
                            'Disconnect this account from the app on this device.',
                        destructive: true,
                        showChevron: false,
                        onTap: authPresenter.isSigningOut
                            ? null
                            : () => _confirmSignOut(context),
                      ),
                    ] else
                      LevelUpActionTile(
                        icon: Icons.login_rounded,
                        title: 'Open account screen',
                        subtitle: 'Go to the full sign up and log in screen.',
                        onTap: () {
                          onOpenAccountScreen();
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                const LevelUpSectionLabel('Preferences'),
                const SizedBox(height: 10),
                _buildSettingsCard(
                  children: [
                    SwitchListTile.adaptive(
                      value: presenter.affirmationsEnabled,
                      activeColor: LevelUpTheme.sage,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 4,
                      ),
                      onChanged: presenter.isLoading
                          ? null
                          : (value) {
                              presenter.setAffirmationsEnabled(value);
                            },
                      title: const Text(
                        'Daily affirmation reminder',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: LevelUpTheme.charcoal,
                        ),
                      ),
                      subtitle: const Text(
                        'A gentle local notification to check in with you each day.',
                        style: TextStyle(
                          fontSize: 13,
                          color: LevelUpTheme.mutedForeground,
                          height: 1.4,
                        ),
                      ),
                    ),
                    if (presenter.affirmationsEnabled) ...[
                      const Divider(height: 1),
                      LevelUpActionTile(
                        icon: Icons.schedule_rounded,
                        title: 'Reminder time',
                        subtitle: 'Pick when your daily reminder should appear.',
                        trailingText: presenter.formattedAffirmationTime,
                        showChevron: false,
                        onTap: () => _pickAffirmationTime(context),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 22),
                const LevelUpSectionLabel('Privacy & Data'),
                const SizedBox(height: 10),
                _buildSettingsCard(
                  children: const [
                    LevelUpActionTile(
                      icon: Icons.storage_outlined,
                      title: 'Data stored',
                      subtitle:
                          'Tasks stay on this device. Account login is handled through Supabase.',
                      showChevron: false,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const LevelUpSectionLabel('About'),
                const SizedBox(height: 10),
                _buildSettingsCard(
                  children: [
                    LevelUpActionTile(
                      icon: Icons.info_outline_rounded,
                      title: 'App version',
                      trailingText: presenter.versionLabel,
                      showChevron: false,
                    ),
                    const Divider(height: 1),
                    const LevelUpActionTile(
                      icon: Icons.favorite_border_rounded,
                      title: 'Made with care',
                      subtitle: 'Level Up is built to support progress, not pressure.',
                      showChevron: false,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const LevelUpSectionLabel('Reset'),
                const SizedBox(height: 10),
                _buildSettingsCard(
                  children: [
                    LevelUpActionTile(
                      icon: Icons.restart_alt_rounded,
                      title: 'Fresh start',
                      subtitle: 'Clear all data and start over.',
                      destructive: true,
                      showChevron: false,
                      onTap: () => _confirmReset(context),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Made with care for your growth \u{1F331}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: LevelUpTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard({
    required List<Widget> children,
  }) {
    return LevelUpCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: children,
      ),
    );
  }
}
