import 'package:flutter/material.dart';

import '../models/task_model.dart';

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
        left: 24,
        right: 24,
        top: 24,
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
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'What would you like to track?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D3060),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _emojiOptions.length,
              itemBuilder: (context, index) {
                final emoji = _emojiOptions[index];
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
                          ? Border.all(
                              color: const Color(0xFF7C6EAF),
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 22),
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
                selectedColor: const Color(0xFFEDE8F5),
                labelStyle: TextStyle(
                  color: isSelected
                      ? const Color(0xFF5A4880)
                      : Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF7C6EAF)
                      : Colors.grey.shade200,
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
