import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Item definition for [CustomBottomNavBar].
class NavBarItem {
  final IconData icon;
  final String label;

  const NavBarItem({required this.icon, required this.label});
}

/// Unified bottom navigation bar with rounded top corners.
/// Supports dynamic navigation item sets for different role dashboards.
///
/// ```dart
/// CustomBottomNavBar(
///   currentIndex: 0,
///   items: const [
///     NavBarItem(icon: Icons.home, label: 'Home'),
///     NavBarItem(icon: Icons.person, label: 'Profile'),
///   ],
///   onTap: (index) => handleTabChange(index),
/// )
/// ```
class CustomBottomNavBar extends StatelessWidget {
  final List<NavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.bottomNavHeight,
      decoration: const BoxDecoration(
        color: AppColors.bottomNavBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radiusXl),
          topRight: Radius.circular(AppDimens.radiusXl),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isActive = index == currentIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 72,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: isActive ? Colors.white : Colors.white70,
                    size: isActive ? AppDimens.iconLg : AppDimens.iconMd,
                  ),
                  const SizedBox(height: AppDimens.xs),
                  Text(
                    item.label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isActive ? Colors.white : Colors.white70,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
