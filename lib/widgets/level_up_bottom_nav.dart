import 'package:flutter/material.dart';

import '../theme/level_up_theme.dart';

class LevelUpBottomNav extends StatelessWidget {
  const LevelUpBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _items = <_LevelUpNavItem>[
    _LevelUpNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _LevelUpNavItem(
      label: 'Rewards',
      icon: Icons.redeem_outlined,
      selectedIcon: Icons.redeem_rounded,
    ),
    _LevelUpNavItem(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: LevelUpTheme.border),
          boxShadow: LevelUpTheme.elevatedShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            children: List<Widget>.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == selectedIndex;

              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => onDestinationSelected(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            width: 34,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? LevelUpTheme.sage
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          Icon(
                            isSelected ? item.selectedIcon : item.icon,
                            color: isSelected
                                ? LevelUpTheme.sage
                                : LevelUpTheme.mutedForeground,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: isSelected
                                  ? LevelUpTheme.sage
                                  : LevelUpTheme.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _LevelUpNavItem {
  const _LevelUpNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
