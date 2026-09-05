import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Section title text (e.g. "Meetings", "Events", "Notes", "Members").
/// Optionally shows a trailing widget (e.g. chevron, filter dropdown).
///
/// ```dart
/// SectionHeader(title: 'Meetings')
/// SectionHeader(
///   title: 'Members',
///   trailing: Text('August ▼'),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.sm),
      child: Row(
        children: [
          Text(title, style: AppTextStyles.sectionHeader),
          if (trailing != null) ...[
            const Spacer(),
            trailing!,
          ],
        ],
      ),
    );
  }
}
