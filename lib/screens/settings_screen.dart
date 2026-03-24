import 'package:flutter/material.dart';

import '../presenters/settings_presenter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.presenter,
    required this.onResetAll,
  });

  final SettingsPresenter presenter;
  final Future<void> Function() onResetAll;

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Fresh Start?'),
        content: const Text(
          'This will clear all your tasks, XP, streak, and today\'s check-in. Your progress will be reset. This cannot be undone.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep going'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: presenter,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAF8F5),
          appBar: AppBar(
            backgroundColor: const Color(0xFFFAF8F5),
            elevation: 0,
            title: const Text(
              'Settings \u2699\uFE0F',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF3D3060),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _sectionHeader('About'),
              _settingsCard([
                _infoTile('App', 'Level Up'),
                _infoTile('Version', presenter.versionLabel),
                _infoTile('Made with', '\u{1F499} Flutter'),
              ]),
              const SizedBox(height: 24),
              _sectionHeader('Affirmations'),
              _settingsCard([
                SwitchListTile(
                  value: presenter.affirmationsEnabled,
                  activeColor: const Color(0xFF7C6EAF),
                  onChanged: presenter.isLoading
                      ? null
                      : (value) {
                          presenter.setAffirmationsEnabled(value);
                        },
                  title: const Text('Daily affirmation reminder'),
                  subtitle: const Text(
                    'A gentle local notification to check in with you each day.',
                  ),
                ),
                if (presenter.affirmationsEnabled)
                  ListTile(
                    leading: const Icon(
                      Icons.schedule_outlined,
                      color: Color(0xFF7C6EAF),
                    ),
                    title: const Text('Reminder time'),
                    subtitle: Text(presenter.formattedAffirmationTime),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _pickAffirmationTime(context);
                    },
                  ),
              ]),
              const SizedBox(height: 24),
              _sectionHeader('A note for you'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '"Progress, not perfection. Every small step you take matters. This app is here to celebrate what you do, not judge what you do not."',
                  style: TextStyle(
                    color: Color(0xFF5A4880),
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              _sectionHeader('Data & Privacy'),
              _settingsCard([
                const ListTile(
                  leading: Icon(
                    Icons.storage_outlined,
                    color: Color(0xFF7C6EAF),
                  ),
                  title: Text('Data stored'),
                  subtitle: Text('Only on your device - never online'),
                  trailing: Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF9FC5A0),
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              _sectionHeader('Reset'),
              _settingsCard([
                ListTile(
                  leading: Icon(Icons.refresh, color: Colors.red.shade300),
                  title: Text(
                    'Fresh start',
                    style: TextStyle(color: Colors.red.shade400),
                  ),
                  subtitle: const Text('Clear all data and start over'),
                  onTap: () => _confirmReset(context),
                ),
              ]),
              const SizedBox(height: 40),
              Text(
                "You're doing great. Keep going. \u{1F331}",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF7C6EAF),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: Text(
        value,
        style: const TextStyle(color: Color(0xFF7C6EAF), fontSize: 14),
      ),
    );
  }
}
