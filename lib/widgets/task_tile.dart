import 'package:flutter/material.dart';

import '../models/task_model.dart';

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
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (glow > 0)
                      BoxShadow(
                        color: const Color(0xFF9FC5A0).withOpacity(glow * 0.18),
                        blurRadius: 18,
                        spreadRadius: glow * 2,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: child,
              );
            },
            child: Material(
              color: widget.task.isCompleted
                  ? const Color(0xFFEFF7EF)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: widget.onToggle,
                onLongPress:
                    widget.onDelete != null ? () => _showDeleteDialog(context) : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.task.isCompleted
                          ? const Color(0xFF9FC5A0).withOpacity(0.55)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: widget.categoryColor.withOpacity(
                            widget.task.isCompleted ? 0.14 : 0.1,
                          ),
                          borderRadius: BorderRadius.circular(12),
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
                                fontWeight: FontWeight.w600,
                                decoration: widget.task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: widget.task.isCompleted
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                if (widget.categoryLabel != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.categoryColor.withOpacity(0.1),
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
                                Text(
                                  widget.task.isCompleted
                                      ? 'That counts.'
                                      : '+${widget.task.xpValue} XP',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: widget.task.isCompleted
                                        ? Colors.grey.shade500
                                        : const Color(0xFF7C6EAF),
                                    fontWeight: FontWeight.w600,
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
                                Icons.check_circle,
                                key: ValueKey('checked'),
                                color: Color(0xFF9FC5A0),
                                size: 30,
                              )
                            : Icon(
                                Icons.radio_button_unchecked,
                                key: const ValueKey('unchecked'),
                                color: Colors.grey.shade300,
                                size: 30,
                              ),
                      ),
                    ],
                  ),
                ),
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
                      color: const Color(0xFF7C6EAF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '+${widget.xpGain} XP',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove task?'),
        content: Text('Remove "${widget.task.label}" from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep it'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
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
