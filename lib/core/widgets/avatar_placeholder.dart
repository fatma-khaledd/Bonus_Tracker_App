import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Circular avatar showing either a network image or a fallback person icon.
///
/// ```dart
/// AvatarPlaceholder(radius: 22)
/// AvatarPlaceholder(radius: 28, imageUrl: user.photoUrl)
/// ```
class AvatarPlaceholder extends StatelessWidget {
  final double radius;
  final String? imageUrl;
  final Color? backgroundColor;
  final IconData? icon;

  const AvatarPlaceholder({
    super.key,
    this.radius = 22,
    this.imageUrl,
    this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? AppColors.surfaceVariant,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Icon(
              icon ?? Icons.person,
              size: radius * 0.9,
              color: AppColors.secondary,
            )
          : null,
    );
  }
}
