import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../shared/models/models.dart';
import '../cubit/member_profile_cubit.dart';
import '../cubit/member_profile_state.dart';
import '../widgets/add_mohsen_dialog.dart';
import '../widgets/attendance_section.dart';
import '../widgets/member_header_info.dart';
import '../widgets/mohsen_warning_summary_row.dart';
import '../widgets/performance_section.dart';
import '../widgets/tasks_section.dart';

class MemberProfileScreen extends StatelessWidget {
  final String committeeId;
  final String memberId;
  final MemberModel? initialMember;
  final String? imageUrl;
  final String displayName;
  final double scorePercent;
  final int mohsensCount;
  final int warningsCount;

  const MemberProfileScreen({
    super.key,
    this.committeeId = 'preview_committee',
    this.memberId = 'preview_member',
    this.initialMember,
    this.imageUrl,
    this.displayName = 'Name',
    this.scorePercent = 0.0,
    this.mohsensCount = 0,
    this.warningsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveInitialMember =
        initialMember ??
        MemberModel(
          userId: memberId,
          displayName: displayName,
          role: MemberRole.member,
          joinedAt: DateTime.now(),
          stats: MemberStats(
            mohsensCount: mohsensCount,
            warningsCount: warningsCount,
            lastUpdatedAt: DateTime.now(),
          ),
          committeeId: committeeId,
        );

    return BlocProvider(
      create: (context) => MemberProfileCubit()
        ..loadMemberProfile(
          committeeId: committeeId,
          memberId: memberId,
          initialMember: effectiveInitialMember,
        ),
      child: _MemberProfileView(
        committeeId: committeeId,
        memberId: memberId,
        imageUrl: imageUrl,
        fallbackScorePercent: scorePercent,
      ),
    );
  }
}

class _MemberProfileView extends StatelessWidget {
  final String committeeId;
  final String memberId;
  final String? imageUrl;
  final double fallbackScorePercent;

  const _MemberProfileView({
    required this.committeeId,
    required this.memberId,
    this.imageUrl,
    required this.fallbackScorePercent,
  });

  void _onMohsenAdded(BuildContext context, AddMohsenResult result) {
    context.read<MemberProfileCubit>().addMohsenOrWarning(
      committeeId: committeeId,
      memberId: memberId,
      title: result.title,
      value: result.value,
      reason: result.reason,
      isMohsen: true,
    );
  }

  void _onWarningAdded(BuildContext context, AddMohsenResult result) {
    context.read<MemberProfileCubit>().addMohsenOrWarning(
      committeeId: committeeId,
      memberId: memberId,
      title: result.title,
      value: result.value,
      reason: result.reason,
      isMohsen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const AppTopBar(notificationCount: 0),
      body: BlocConsumer<MemberProfileCubit, MemberProfileState>(
        listener: (context, state) {
          if (state.actionSuccessMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.actionSuccessMessage!,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                ),
              ),
            );
            context.read<MemberProfileCubit>().clearActionMessage();
          } else if (state.status == MemberProfileStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage!,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == MemberProfileStatus.loading &&
              state.member == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final effectiveScore = state.monthlyStats != null
              ? state.scorePercent
              : fallbackScorePercent;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.screenPaddingH,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.md),

                  //1. Member Header (Avatar, Name, Progress, Send Email)
                  MemberHeaderInfo(
                    displayName: state.displayName.isNotEmpty
                        ? state.displayName
                        : 'Name',
                    scorePercent: effectiveScore,
                    imageUrl: imageUrl,
                    onSendEmail: () {
                      // send email action
                    },
                  ),
                  const SizedBox(height: AppDimens.lg),

                  //2. Mohsens / Warnings Summary Boxes
                  MohsenWarningSummaryRow(
                    mohsensCount: state.mohsensCount,
                    warningsCount: state.warningsCount,
                    onMohsenAdded: (result) => _onMohsenAdded(context, result),
                    onWarningAdded: (result) =>
                        _onWarningAdded(context, result),
                  ),
                  const SizedBox(height: AppDimens.lg),

                  //3. Tasks Section
                  TasksSection(
                    key: ValueKey('tasks_${state.sessionRecords.length}'),
                    initialTasks: state.taskSessionItems,
                    onTaskStatusChanged: (index, newStatus) {
                      context.read<MemberProfileCubit>().updateTaskStatus(
                        index,
                        newStatus,
                      );
                    },
                  ),
                  const SizedBox(height: AppDimens.md),

                  //4. Attendance Section
                  AttendanceSection(
                    key: ValueKey('attendance_${state.sessionRecords.length}'),
                    initialAttendance: state.attendanceSessionItems,
                    onAttendanceChanged: (index, newStatus) {
                      context.read<MemberProfileCubit>().updateAttendanceStatus(
                        index,
                        newStatus,
                      );
                    },
                  ),
                  const SizedBox(height: AppDimens.md),

                  //5. Performance Section
                  PerformanceSection(
                    key: ValueKey(
                      'perf_${state.member?.stats.lastUpdatedAt.millisecondsSinceEpoch ?? 0}',
                    ),
                    initialSessionsChecked: state.sessionTraitsChecked,
                  ),
                  const SizedBox(height: AppDimens.lg),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
