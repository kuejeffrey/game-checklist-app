import 'package:flutter/material.dart';

import '../theme/level_up_theme.dart';

class LevelUpTextField extends StatelessWidget {
  const LevelUpTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.validator,
    this.enabled = true,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction,
    this.autofillHints,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: LevelUpTheme.charcoal,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          enabled: enabled,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          onFieldSubmitted: onFieldSubmitted,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
