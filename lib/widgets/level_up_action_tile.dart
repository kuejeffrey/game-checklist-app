import 'package:flutter/material.dart';

import '../theme/level_up_theme.dart';

class LevelUpActionTile extends StatelessWidget {
  const LevelUpActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final foregroundColor =
        destructive ? LevelUpTheme.destructive : LevelUpTheme.charcoal;
    final iconBackgroundColor = destructive
        ? LevelUpTheme.destructive.withOpacity(0.12)
        : LevelUpTheme.sage.withOpacity(0.12);
    final iconColor =
        destructive ? LevelUpTheme.destructive : LevelUpTheme.sage;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: foregroundColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: LevelUpTheme.mutedForeground,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (trailingText != null)
                Text(
                  trailingText!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: LevelUpTheme.mutedForeground,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else if (showChevron)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: LevelUpTheme.mutedForeground,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
