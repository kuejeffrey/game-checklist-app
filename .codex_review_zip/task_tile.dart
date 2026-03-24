// ============================================================
// widgets/task_tile.dart — Single Task Row
//
// Displays one task with its emoji, label, XP value,
// and a checkbox. Tapping anywhere toggles completion.
// Custom (non-default) tasks show a delete button on long-press.
// ============================================================

import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback? onDelete; // null for default tasks (can't delete)

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      onLongPress: onDelete != null
          ? () => _showDeleteDialog(context)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          // Completed tasks get a soft green tint
          color: task.isCompleted
              ? const Color(0xFFEFF7EF)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: task.isCompleted
                ? const Color(0xFF9FC5A0).withOpacity(0.5)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [

            // ── Emoji Icon ──────────────────────────────────
            Text(
              task.emoji,
              style: TextStyle(
                fontSize: 24,
                // Slightly faded when complete
                color: task.isCompleted ? null : null,
              ),
            ),

            const SizedBox(width: 14),

            // ── Task Label ──────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      // Strikethrough when completed
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.isCompleted
                          ? Colors.grey.shade400
                          : Colors.grey.shade800,
                    ),
                  ),

                  // XP badge shown only when not completed
                  if (!task.isCompleted)
                    Text(
                      '+${task.xpValue} XP',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7C6EAF),
                      ),
                    ),
                ],
              ),
            ),

            // ── Checkmark / Checkbox ────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: task.isCompleted
                  ? const Icon(
                      Icons.check_circle,
                      key: ValueKey('checked'),
                      color: Color(0xFF9FC5A0),
                      size: 26,
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      key: const ValueKey('unchecked'),
                      color: Colors.grey.shade300,
                      size: 26,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Delete Dialog (for custom tasks) ──────────────────────
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove task?'),
        content: Text('Remove "${task.label}" from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep it'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
            onPressed: () {
              Navigator.pop(ctx);
              onDelete?.call();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
