
import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'avatar_placeholder.dart';

class NotificationListTile extends StatelessWidget {
  final String name;
  final String role;
  final String title;
  final String message;
  final bool isRead;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const NotificationListTile({
    super.key,
    required this.name,
    required this.role,
    required this.title,
    required this.message,
    this.isRead = false,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.lg,
          vertical: AppDimens.md,
        ),
        color: isRead ? Colors.transparent : AppColors.surfaceLight,
        child: Row(
          children: [
            AvatarPlaceholder(
              radius: AppDimens.avatarMd / 2,
              imageUrl: avatarUrl,
            ),
            const SizedBox(width: AppDimens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.bodyBold,
                      ),
                      const SizedBox(width: AppDimens.sm),
                      Text(
                        role,
                        style: AppTextStyles.notificationRole,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.xs),
                  Text(
                    title,
                    style: AppTextStyles.bodyBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.xs),
                  Text(
                    message,
                    style: isRead
                        ? AppTextStyles.notificationRead
                        : AppTextStyles.notificationUnread,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

