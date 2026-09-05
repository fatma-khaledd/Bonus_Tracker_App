import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Single criteria row in the Member Profile performance table.
/// Displays criterion name along with checkboxes for Sessions and Events.
///
/// ```dart
/// PerformanceCheckRow(
///   label: 'Teamwork',
///   sessionsChecked: true,
///   eventsChecked: false,
///   onSessionsChanged: (val) => updateSessions(val),
///   onEventsChanged: (val) => updateEvents(val),
/// )
/// ```
class PerformanceCheckRow extends StatelessWidget {
  final String label;
  final bool sessionsChecked;
  final bool eventsChecked;
  final ValueChanged<bool?>? onSessionsChanged;
  final ValueChanged<bool?>? onEventsChanged;

  const PerformanceCheckRow({
    super.key,
    required this.label,
    required this.sessionsChecked,
    required this.eventsChecked,
    this.onSessionsChanged,
    this.onEventsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.xs),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: AppTextStyles.bodyBold,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: sessionsChecked,
                  onChanged: onSessionsChanged,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: eventsChecked,
                  onChanged: onEventsChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
