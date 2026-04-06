import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../theme/level_up_theme.dart';
import 'level_up_badge.dart';
import 'level_up_card.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.categoryColor,
    this.categoryLabel,
    this.showCelebration = false,
    this.xpGain = 0,
    this.onDelete,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;
  final String? categoryLabel;
  final Color categoryColor;
  final bool showCelebration;
  final int xpGain;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _xpFadeAnimation;
  late final Animation<Offset> _xpSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 1.03)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 45,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.03, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 55,
      ),
    ]).animate(_controller);
    _xpFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.08, 0.7, curve: Curves.easeOut),
    );
    _xpSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: const Offset(0.0, -0.55),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant TaskTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showCelebration && !oldWidget.showCelebration) {
      _controller.forward(from: 0);
    } else if (!widget.showCelebration && oldWidget.showCelebration) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final glow = _controller.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    if (glow > 0)
                      BoxShadow(
                        color: LevelUpTheme.sage.withOpacity(glow * 0.16),
                        blurRadius: 18,
                        spreadRadius: glow * 2,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: child,
              );
            },
            child: LevelUpCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              radius: 22,
              color:
                  widget.task.isCompleted ? const Color(0xFFF8FBF8) : Colors.white,
              borderColor: widget.task.isCompleted
                  ? LevelUpTheme.sage.withOpacity(0.28)
                  : LevelUpTheme.border,
              boxShadow: const [],
              onTap: widget.onToggle,
              onLongPress:
                  widget.onDelete != null ? () => _showDeleteDialog(context) : null,
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.categoryColor.withOpacity(
                        widget.task.isCompleted ? 0.16 : 0.12,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.task.emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.label,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            decoration: widget.task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: widget.task.isCompleted
                                ? LevelUpTheme.mutedForeground
                                : LevelUpTheme.charcoal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (widget.categoryLabel != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.categoryColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  widget.categoryLabel!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: widget.categoryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            LevelUpBadge(
                              label: widget.task.isCompleted
                                  ? 'Completed'
                                  : '+${widget.task.xpValue} XP',
                              tone: widget.task.isCompleted
                                  ? LevelUpBadgeTone.success
                                  : LevelUpBadgeTone.gold,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: widget.task.isCompleted
                        ? const Icon(
                            Icons.check_circle_rounded,
                            key: ValueKey('checked'),
                            color: LevelUpTheme.sage,
                            size: 30,
                          )
                        : const Icon(
                            Icons.radio_button_unchecked_rounded,
                            key: ValueKey('unchecked'),
                            color: LevelUpTheme.mutedForeground,
                            size: 28,
                          ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -8,
            right: 14,
            child: IgnorePointer(
              child: FadeTransition(
                opacity: _xpFadeAnimation,
                child: SlideTransition(
                  position: _xpSlideAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: LevelUpTheme.sage,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '+${widget.xpGain} XP',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove task?'),
        content: Text('Remove "${widget.task.label}" from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep it'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: LevelUpTheme.destructive,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDelete?.call();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
