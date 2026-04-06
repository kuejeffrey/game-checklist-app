import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../theme/level_up_theme.dart';
import 'level_up_badge.dart';

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
    final isCompleted = widget.task.isCompleted;
    final accentColor = widget.categoryColor;

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
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    ...LevelUpTheme.cardShadow,
                    if (glow > 0)
                      BoxShadow(
                        color: LevelUpTheme.sage.withOpacity(glow * 0.18),
                        blurRadius: 20,
                        spreadRadius: glow * 2,
                        offset: const Offset(0, 6),
                      ),
                  ],
                ),
                child: child,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? LevelUpTheme.muted.withOpacity(0.7)
                        : LevelUpTheme.surface,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: widget.onToggle,
                    onLongPress: widget.onDelete != null
                        ? () => _showDeleteDialog(context)
                        : null,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left accent strip
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 4,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? accentColor.withOpacity(0.3)
                                  : accentColor,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(18),
                              ),
                            ),
                          ),
                          // Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  // Emoji
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: isCompleted ? 0.5 : 1.0,
                                    child: Container(
                                      width: 42,
                                      height: 42,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: accentColor.withOpacity(0.10),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        widget.task.emoji,
                                        style: const TextStyle(fontSize: 21),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Labels
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(
                                              milliseconds: 300),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Nunito',
                                            decoration: isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                            decorationColor:
                                                LevelUpTheme.mutedForeground,
                                            color: isCompleted
                                                ? LevelUpTheme.mutedForeground
                                                : LevelUpTheme.charcoal,
                                          ),
                                          child: Text(widget.task.label),
                                        ),
                                        const SizedBox(height: 6),
                                        LevelUpBadge(
                                          label: isCompleted
                                              ? 'Completed'
                                              : '+${widget.task.xpValue} XP',
                                          tone: isCompleted
                                              ? LevelUpBadgeTone.success
                                              : LevelUpBadgeTone.gold,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Check
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    switchInCurve: Curves.easeOutBack,
                                    switchOutCurve: Curves.easeIn,
                                    transitionBuilder: (child, animation) =>
                                        ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                    child: isCompleted
                                        ? Icon(
                                            Icons.check_circle_rounded,
                                            key: const ValueKey('checked'),
                                            color: LevelUpTheme.sage,
                                            size: 28,
                                          )
                                        : Icon(
                                            Icons.circle_outlined,
                                            key: const ValueKey('unchecked'),
                                            color: LevelUpTheme.mutedForeground
                                                .withOpacity(0.5),
                                            size: 26,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Floating XP pill
          Positioned(
            top: -6,
            right: 12,
            child: IgnorePointer(
              child: FadeTransition(
                opacity: _xpFadeAnimation,
                child: SlideTransition(
                  position: _xpSlideAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: LevelUpTheme.progressBarGradient,
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
