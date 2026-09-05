import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Base card with Surface background and rounded corners.
/// Used as the foundation for StatBox, ListEntryCard, NoteCard, etc.
///
/// ```dart
/// AppCard(
///   child: Text('Hello'),
///   onTap: () => print('tapped'),
/// )
/// ```
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? borderRadius;
  final VoidCallback? onTap;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(AppDimens.cardPadding),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimens.radiusMd,
        ),
        border: border,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}
