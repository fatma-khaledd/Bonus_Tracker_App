import 'package:bonus_tracker_app/core/theme/app_colors.dart';
import 'package:bonus_tracker_app/core/theme/app_text_styles.dart';
import 'package:bonus_tracker_app/core/widgets/widgets.dart';
import 'package:bonus_tracker_app/features/member/cubit/member_cubit.dart';
import 'package:bonus_tracker_app/features/member/cubit/member_states.dart';
import 'package:bonus_tracker_app/features/member/member_widgets/horizontal_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeMemberScreen extends StatelessWidget {
  final MemberSuccessState state;
  const HomeMemberScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MemberCubit>();
    final committees = state.user.committees;
    final stats = state.member.stats;

    return Scaffold(
      appBar: AppTopBar(title: 'Welcome ${state.member.displayName}'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Committees Selector
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: committees.length,
                itemBuilder: (context, index) {
                  final committeeId = committees[index];
                  return GestureDetector(
                    onTap: () => cubit.switchCommittee(committeeId),
                    child: CommitteeChip(
                      label: committeeId,
                      isSelected: committeeId == state.selectedCommitteeId,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Mohsens & Warnings
            Row(
              children: [
                 AppCard(
                    color: AppColors.surfaceDark,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Text('Mohsens', style: AppTextStyles.cardTitle),
                          const SizedBox(height: 40),
                          Text('${stats.mohsensCount}', style: AppTextStyles.cardTitle),
                        ],
                      ),
                    ),
                 ),
                const SizedBox(width: 12),
                 AppCard(
                    color: AppColors.surfaceDark,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Text('Warnings', style: AppTextStyles.cardTitle),
                          const SizedBox(height: 40),
                          Text('${stats.warningsCount}', style: AppTextStyles.cardTitle),
                        ],
                      ),
                    ),
                 ),
               
              ],
            ),

            const SizedBox(height: 24),

            const SectionHeader(title: 'Meetings'),
            HorizontalCardsList(
              count: state.meetings.length,
              emptyText: 'No meetings yet',
              builder: (i) {
                final m = state.meetings[i];
                return ListEntryCard(
                  title: m.title,
                  date: DateFormat('EEE - MM/dd').format(m.date),
                  time: DateFormat('hh:mm a').format(m.date).toLowerCase(),
                );
              },
            ),

            const SizedBox(height: 24),

            const SectionHeader(title: 'Events'),
            HorizontalCardsList(
              count: state.events.length,
              emptyText: 'No events yet',
              builder: (i) {
                final e = state.events[i];
                return ListEntryCard(
                  title: e.title,
                  date: DateFormat('EEE - MM/dd').format(e.date),
                  time: DateFormat('hh:mm a').format(e.date).toLowerCase(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
