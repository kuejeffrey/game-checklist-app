import 'package:flutter/material.dart';

import '../models/mood_model.dart';
import '../theme/level_up_theme.dart';
import 'level_up_card.dart';

class MoodCheckInDialog extends StatefulWidget {
  const MoodCheckInDialog({
    super.key,
    required this.promptText,
    required this.helperText,
  });

  final String promptText;
  final String helperText;

  static Future<int?> show(
    BuildContext context, {
    required String promptText,
    required String helperText,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.22),
      builder: (dialogContext) => MoodCheckInDialog(
        promptText: promptText,
        helperText: helperText,
      ),
    );
  }

  @override
  State<MoodCheckInDialog> createState() => _MoodCheckInDialogState();
}

class _MoodCheckInDialogState extends State<MoodCheckInDialog> {
  int? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: LevelUpCard(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
          radius: 30,
          boxShadow: LevelUpTheme.elevatedShadow,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: LevelUpTheme.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LevelUpTheme.authHeroGradient,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.promptText,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: LevelUpTheme.charcoal,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.helperText,
                style: const TextStyle(
                  fontSize: 14,
                  color: LevelUpTheme.mutedForeground,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.92,
                children: moodOptions.map(_buildMoodOption).toList(),
              ),
              const SizedBox(height: 18),
              if (_selectedLevel != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(_selectedLevel),
                    child: const Text('Continue'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(_selectedLevel == null ? 'Maybe later' : 'Skip for now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodOption(MoodOption option) {
    final isSelected = option.level == _selectedLevel;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          setState(() {
            _selectedLevel = option.level;
          });
        },
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? LevelUpTheme.sage.withOpacity(0.1)
                : LevelUpTheme.muted.withOpacity(0.6),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isSelected ? LevelUpTheme.sage : LevelUpTheme.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                option.emoji,
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 8),
              Text(
                option.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? LevelUpTheme.sage
                      : LevelUpTheme.charcoal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
