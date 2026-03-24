import 'package:flutter/material.dart';

import '../models/mood_model.dart';

class MoodCheckInCard extends StatelessWidget {
  const MoodCheckInCard({
    super.key,
    required this.promptText,
    required this.helperText,
    required this.selectedMood,
    required this.onSelected,
    required this.isLocked,
  });

  final String promptText;
  final String helperText;
  final MoodOption? selectedMood;
  final ValueChanged<int> onSelected;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7DFF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            promptText,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D3060),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            helperText,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moodOptions.map((option) {
              final isSelected = selectedMood?.level == option.level;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Material(
                    color: isSelected
                        ? const Color(0xFFEDE8F5)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: isLocked ? null : () => onSelected(option.level),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF7C6EAF)
                                : Colors.grey.shade200,
                            width: isSelected ? 1.6 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              option.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              option.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xFF5A4880)
                                    : Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
