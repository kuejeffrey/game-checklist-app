// ============================================================
// screens/settings_screen.dart — App Settings
//
// Simple settings page with:
//   - Reset daily tasks option
//   - Clear all data (fresh start)
//   - About section
// ============================================================

import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // ── Confirm and Reset All Data ────────────────────────────
  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Fresh Start?'),
        content: const Text(
          "This will clear all your tasks, XP, and streak. "
          "Your progress will be reset. This can't be undone.",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep going'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset everything'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.clearAll();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8F5),
        elevation: 0,
        title: const Text(
          'Settings ⚙️',
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

          // ── Section: About ─────────────────────────────────
          _sectionHeader('About'),
          _settingsCard([
            _infoTile('App', 'Level Up'),
            _infoTile('Version', '1.0.0 (MVP)'),
            _infoTile('Made with', '💙 Flutter'),
          ]),

          const SizedBox(height: 24),

          // ── Section: Encouragement ─────────────────────────
          _sectionHeader('A note for you'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE8F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              '"Progress, not perfection. Every small step you take matters. '
              'This app is here to celebrate what you do, not judge what you don\'t."',
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

          // ── Section: Data ──────────────────────────────────
          _sectionHeader('Data & Privacy'),
          _settingsCard([
            ListTile(
              leading: const Icon(Icons.storage_outlined, color: Color(0xFF7C6EAF)),
              title: const Text('Data stored'),
              subtitle: const Text('Only on your device — never online'),
              trailing: const Icon(Icons.check_circle_outline, color: Color(0xFF9FC5A0)),
            ),
          ]),

          const SizedBox(height: 24),

          // ── Section: Danger Zone ───────────────────────────
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

          // ── Footer ─────────────────────────────────────────
          Text(
            'You\'re doing great. Keep going. 🌱',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Helper Widgets ─────────────────────────────────────────
  Widget _sectionHeader(String title) => Padding(
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

  Widget _settingsCard(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(children: children),
  );

  Widget _infoTile(String label, String value) => ListTile(
    title: Text(label, style: const TextStyle(fontSize: 14)),
    trailing: Text(
      value,
      style: const TextStyle(color: Color(0xFF7C6EAF), fontSize: 14),
    ),
  );
}
