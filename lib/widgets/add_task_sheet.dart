import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../theme/level_up_theme.dart';

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

  String _selectedEmoji = '\u{1F4DD}';
  TaskCategory _selectedCategory = TaskCategory.wellness;

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  void _submit() {
    final label = _labelController.text.trim();
    if (label.isEmpty) return;
    widget.onAdd(label, _selectedEmoji, _selectedCategory);
    Navigator.pop(context);
  }

  void _openEmojiPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SizedBox(
        height: 380,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: LevelUpTheme.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: EmojiPicker(
                onEmojiSelected: (Category? category, Emoji emoji) {
                  setState(() => _selectedEmoji = emoji.emoji);
                  Navigator.pop(context);
                },
                config: Config(
                  height: 340,
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    backgroundColor: Colors.white,
                    emojiSizeMax: 28,
                  ),
                  searchViewConfig: const SearchViewConfig(
                    backgroundColor: Colors.white,
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    backgroundColor: Colors.white,
                    iconColor: LevelUpTheme.mutedForeground,
                    iconColorSelected: LevelUpTheme.sage,
                    indicatorColor: LevelUpTheme.sage,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: bottomPadding + 28,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: LevelUpTheme.muted,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Header row: emoji picker button + title
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tappable emoji button
              GestureDetector(
                onTap: _openEmojiPicker,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: LevelUpTheme.muted,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: LevelUpTheme.sage.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        _selectedEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: LevelUpTheme.sage,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'New task',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: LevelUpTheme.charcoal,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: _openEmojiPicker,
                      child: Text(
                        'Tap emoji to change',
                        style: TextStyle(
                          fontSize: 12,
                          color: LevelUpTheme.sage,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Category chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TaskCategory.values.map((category) {
              final isSelected = category == _selectedCategory;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? LevelUpTheme.sage.withOpacity(0.12)
                          : LevelUpTheme.muted,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? LevelUpTheme.sage
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      '${category.emoji} ${category.label}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? LevelUpTheme.sage
                            : LevelUpTheme.mutedForeground,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Task label field
          TextField(
            controller: _labelController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: LevelUpTheme.charcoal,
            ),
            decoration: InputDecoration(
              hintText: 'What do you want to track?',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    _selectedEmoji,
                    style: const TextStyle(fontSize: 20),
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
          const SizedBox(height: 16),

          // Submit button
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
