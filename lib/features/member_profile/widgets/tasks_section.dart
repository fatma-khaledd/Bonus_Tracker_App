import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/task_status_dropdown_chip.dart';

// Represents a session name and its task status
class TaskSessionItem {
  final String sessionName;
  final String status;

  const TaskSessionItem({
    required this.sessionName,
    required this.status,
  });

  TaskSessionItem copyWith({String? sessionName, String? status}) {
    return TaskSessionItem(
      sessionName: sessionName ?? this.sessionName,
      status: status ?? this.status,
    );
  }
}

// Tasks section showing session task statuses with dropdown chips
class TasksSection extends StatefulWidget {
  final List<TaskSessionItem>? initialTasks;
  final List<String>? taskOptions;
  final void Function(int index, String newStatus)? onTaskStatusChanged;

  const TasksSection({
    super.key,
    this.initialTasks,
    this.taskOptions,
    this.onTaskStatusChanged,
  });

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  late List<TaskSessionItem> _tasks;

  static const List<String> _defaultTaskOptions = [
    'Completed early',
    'Late excused',
    'Not delivered',
    'None',
  ];

  @override
  void initState() {
    super.initState();
    _tasks = List<TaskSessionItem>.from(widget.initialTasks ??
        const [
          TaskSessionItem(sessionName: 'Session1', status: 'None'),
          TaskSessionItem(sessionName: 'Session2', status: 'None'),
          TaskSessionItem(sessionName: 'Session3', status: 'None'),
          TaskSessionItem(sessionName: 'Session4', status: 'None'),
        ]);
  }

  @override
  void didUpdateWidget(covariant TasksSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTasks != null &&
        widget.initialTasks != oldWidget.initialTasks) {
      setState(() {
        _tasks = List<TaskSessionItem>.from(widget.initialTasks!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.taskOptions ?? _defaultTaskOptions;

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
            'Tasks:',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimens.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_tasks.length, (index) {
                final task = _tasks[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < _tasks.length - 1 ? AppDimens.sm : 0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.sessionName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppDimens.xs),
                      TaskStatusDropdownChip(
                        currentStatus: task.status,
                        options: options,
                        onChanged: (newVal) {
                          setState(() {
                            _tasks[index] = task.copyWith(status: newVal);
                          });
                          widget.onTaskStatusChanged?.call(index, newVal);
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
