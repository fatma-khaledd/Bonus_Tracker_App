import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/performance_check_row.dart';

// Performance traits section with checkboxes for sessions and events
class PerformanceSection extends StatefulWidget {
  final Map<String, bool>? initialSessionsChecked;
  final Map<String, bool>? initialEventsChecked;
  final void Function(String trait, bool checked)? onSessionChanged;
  final void Function(String trait, bool checked)? onEventChanged;

  const PerformanceSection({
    super.key,
    this.initialSessionsChecked,
    this.initialEventsChecked,
    this.onSessionChanged,
    this.onEventChanged,
  });

  @override
  State<PerformanceSection> createState() => _PerformanceSectionState();
}

class _PerformanceSectionState extends State<PerformanceSection> {
  static const List<String> _traits = [
    'Activeness',
    'Teamwork',
    'Flexibility',
    'Good attitude',
    'Bad attitude',
  ];

  late Map<String, bool> _sessionsChecked;
  late Map<String, bool> _eventsChecked;

  @override
  void initState() {
    super.initState();
    _sessionsChecked = widget.initialSessionsChecked ??
        {
          'Activeness': true,
          'Teamwork': true,
          'Flexibility': true,
          'Good attitude': true,
          'Bad attitude': true,
        };

    _eventsChecked = widget.initialEventsChecked ??
        {
          'Activeness': false,
          'Teamwork': false,
          'Flexibility': false,
          'Good attitude': false,
          'Bad attitude': false,
        };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance:',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimens.xs),
          Row(
            children: [
              const Expanded(flex: 3, child: SizedBox.shrink()),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'Sessions',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'Events',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.xs),
          ..._traits.map((trait) {
            return PerformanceCheckRow(
              label: trait,
              sessionsChecked: _sessionsChecked[trait] ?? false,
              eventsChecked: _eventsChecked[trait] ?? false,
              onSessionsChanged: (val) {
                setState(() {
                  _sessionsChecked[trait] = val ?? false;
                });
                widget.onSessionChanged?.call(trait, val ?? false);
              },
              onEventsChanged: (val) {
                setState(() {
                  _eventsChecked[trait] = val ?? false;
                });
                widget.onEventChanged?.call(trait, val ?? false);
              },
            );
          }),
        ],
      ),
    );
  }
}
