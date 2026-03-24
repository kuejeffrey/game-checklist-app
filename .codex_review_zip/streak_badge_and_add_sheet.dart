// ============================================================
// widgets/streak_badge.dart — Streak Counter Badge
// ============================================================

import 'package:flutter/material.dart';

class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    // Color intensity grows with streak
    final isHot = streak >= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isHot
            ? const Color(0xFFFFEDD5)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isHot ? '🔥' : '⭐',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isHot
                  ? const Color(0xFFB85A00)
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// widgets/add_task_sheet.dart — Bottom Sheet for Adding Tasks
//
// A soft bottom sheet that slides up when the user taps
// "Add your own task". They can type a name and pick an emoji.
// ============================================================

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddTaskSheet extends StatefulWidget {
  final Function(String label, String emoji) onAdd;

  const AddTaskSheet({super.key, required this.onAdd});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final TextEditingController _labelController = TextEditingController();
  String _selectedEmoji = '📝'; // Default emoji

  // A small grid of emoji options for the user to pick
  static const List<String> _emojiOptions = [
    '📝', '🏃', '📚', '💊', '🧘', '🎨',
    '🎵', '🌿', '🧹', '📞', '💌', '🛒',
    '🐾', '🌊', '🍎', '🎯',
  ];

  void _submit() {
    final label = _labelController.text.trim();
    if (label.isEmpty) return;

    widget.onAdd(label, _selectedEmoji);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Padding accounts for the keyboard so the sheet slides up
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: bottomPadding + 32,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Sheet Handle ─────────────────────────────────
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "What would you like to track?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D3060),
            ),
          ),

          const SizedBox(height: 16),

          // ── Emoji Picker ──────────────────────────────────
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _emojiOptions.length,
              itemBuilder: (ctx, i) {
                final emoji = _emojiOptions[i];
                final isSelected = emoji == _selectedEmoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 8),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFEDE8F5)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: const Color(0xFF7C6EAF), width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Task Name Input ───────────────────────────────
          TextField(
            controller: _labelController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'e.g. Take my medication',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              prefixText: '$_selectedEmoji  ',
            ),
            onSubmitted: (_) => _submit(),
          ),

          const SizedBox(height: 16),

          // ── Add Button ─────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C6EAF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Add to my list',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
