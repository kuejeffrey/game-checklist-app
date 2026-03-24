import 'package:flutter/material.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({
    super.key,
    required this.streak,
  });

  final int streak;

  @override
  Widget build(BuildContext context) {
    final isHot = streak >= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isHot ? const Color(0xFFFFEDD5) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isHot ? '\u{1F525}' : '\u2B50',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color:
                  isHot ? const Color(0xFFB85A00) : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
