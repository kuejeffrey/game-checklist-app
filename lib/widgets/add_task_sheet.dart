import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../theme/level_up_theme.dart';
import 'level_up_badge.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({
    super.key,
    required this.onAdd,
  });

  final void Function(String label, String emoji, TaskCategory category) onAdd;

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final TextEditingController _labelController = TextEditingController();

  static const List<String> _emojiOptions = [
    '\u{1F4DD}',
    '\u{1F3C3}',
    '\u{1F4DA}',
    '\u{1F48A}',
    '\u{1F9D8}',
    '\u{1F3A8}',
    '\u{1F3B5}',
    '\u{1F33F}',
    '\u{1F9F9}',
    '\u{1F4DE}',
    '\u{1F48C}',
    '\u{1F6D2}',
    '\u{1F43E}',
    '\u{1F30A}',
    '\u{1F34E}',
    '\u{1F3AF}',
  ];

  String _selectedEmoji = _emojiOptions.first;
  TaskCategory _selectedCategory = TaskCategory.wellness;

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  void _submit() {
    final label = _labelController.text.trim();
    if (label.isEmpty) {
      return;
    }

    widget.onAdd(label, _selectedEmoji, _selectedCategory);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 18,
        bottom: bottomPadding + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: LevelUpTheme.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const LevelUpBadge(
            label: 'Add a task',
            tone: LevelUpBadgeTone.sage,
          ),
          const SizedBox(height: 12),
          const Text(
            'What would you like to track today?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: LevelUpTheme.charcoal,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pick an emoji, choose a category, and add a short label.',
            style: TextStyle(
              fontSize: 14,
              color: LevelUpTheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _emojiOptions.length,
              itemBuilder: (context, index) {
                final emoji = _emojiOptions[index];
                final isSelected = emoji == _selectedEmoji;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => setState(() => _selectedEmoji = emoji),
                      child: Ink(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? LevelUpTheme.sage.withOpacity(0.12)
                              : LevelUpTheme.muted,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                isSelected ? LevelUpTheme.sage : LevelUpTheme.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 23),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TaskCategory.values.map((category) {
              final isSelected = category == _selectedCategory;
              return ChoiceChip(
                label: Text('${category.emoji} ${category.label}'),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedCategory = category),
                backgroundColor: LevelUpTheme.muted,
                selectedColor: LevelUpTheme.sage.withOpacity(0.12),
                side: BorderSide(
                  color: isSelected ? LevelUpTheme.sage : LevelUpTheme.border,
                ),
                labelStyle: TextStyle(
                  color: isSelected
                      ? LevelUpTheme.sage
                      : LevelUpTheme.charcoal,
                  fontWeight: FontWeight.w700,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _labelController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Take my medication',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    _selectedEmoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: const Text('Add to my list'),
            ),
          ),
        ],
      ),
    );
  }
}
