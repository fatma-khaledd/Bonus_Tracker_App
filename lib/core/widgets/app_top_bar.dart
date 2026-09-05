import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Standard top header bar displaying app logo, theme toggle, and notification bell with badge.
///
/// ```dart
/// AppTopBar(
///   notificationCount: 3,
///   onNotificationTap: () => openNotifications(),
///   onThemeToggle: () => toggleTheme(),
/// )
/// ```
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onThemeToggle;
  final VoidCallback? onNotificationTap;
  final int notificationCount;
  final String? title;
  final bool isDarkMode;

  const AppTopBar({
    super.key,
    this.onThemeToggle,
    this.onNotificationTap,
    this.notificationCount = 0,
    this.title,
    this.isDarkMode = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.topBarHeight);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.screenPaddingH,
          vertical: AppDimens.sm,
        ),
        child: Row(
          children: [
            // App Sun Icon
            const Icon(
              Icons.wb_sunny,
              color: AppColors.primary,
              size: AppDimens.iconLg,
            ),
            const SizedBox(width: AppDimens.sm),

            // Dark Mode Toggle Icon
            GestureDetector(
              onTap: onThemeToggle,
              child: Icon(
                isDarkMode ? Icons.dark_mode : Icons.dark_mode_outlined,
                color: AppColors.secondary,
                size: AppDimens.iconMd,
              ),
            ),

            if (title != null) ...[
              const Spacer(),
              Text(title!, style: AppTextStyles.heading2),
              const Spacer(),
            ] else
              const Spacer(),

            // Notification Bell with Badge
            GestureDetector(
              onTap: onNotificationTap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications,
                    color: AppColors.secondary,
                    size: AppDimens.iconLg,
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: AppColors.notificationBadge,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          notificationCount > 9
                              ? '9+'
                              : notificationCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
