import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/task_status_dropdown_chip.dart';

// Represents a session name and its attendance status
class AttendanceSessionItem {
  final String sessionName;
  final String status;

  const AttendanceSessionItem({
    required this.sessionName,
    required this.status,
  });

  AttendanceSessionItem copyWith({String? sessionName, String? status}) {
    return AttendanceSessionItem(
      sessionName: sessionName ?? this.sessionName,
      status: status ?? this.status,
    );
  }
}

// Attendance section showing session attendance statuses with dropdown chips
class AttendanceSection extends StatefulWidget {
  final List<AttendanceSessionItem>? initialAttendance;
  final List<String>? attendanceOptions;
  final void Function(int index, String newStatus)? onAttendanceChanged;

  const AttendanceSection({
    super.key,
    this.initialAttendance,
    this.attendanceOptions,
    this.onAttendanceChanged,
  });

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  late List<AttendanceSessionItem> _attendanceList;

  static const List<String> _defaultAttendanceOptions = [
    'On time',
    'Late excused',
    'Late unexcused',
    'Absent excused',
  ];

  @override
  void initState() {
    super.initState();
    _attendanceList = List<AttendanceSessionItem>.from(widget.initialAttendance ??
        const [
          AttendanceSessionItem(sessionName: 'Session1', status: 'On time'),
          AttendanceSessionItem(sessionName: 'Session2', status: 'On time'),
          AttendanceSessionItem(sessionName: 'Session3', status: 'On time'),
          AttendanceSessionItem(sessionName: 'Session4', status: 'On time'),
        ]);
  }

  @override
  void didUpdateWidget(covariant AttendanceSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialAttendance != null &&
        widget.initialAttendance != oldWidget.initialAttendance) {
      setState(() {
        _attendanceList =
            List<AttendanceSessionItem>.from(widget.initialAttendance!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.attendanceOptions ?? _defaultAttendanceOptions;

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
            'Attendance:',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimens.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_attendanceList.length, (index) {
                final item = _attendanceList[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < _attendanceList.length - 1 ? AppDimens.sm : 0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.sessionName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppDimens.xs),
                      TaskStatusDropdownChip(
                        currentStatus: item.status,
                        options: options,
                        onChanged: (newVal) {
                          setState(() {
                            _attendanceList[index] = item.copyWith(status: newVal);
                          });
                          widget.onAttendanceChanged?.call(index, newVal);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
