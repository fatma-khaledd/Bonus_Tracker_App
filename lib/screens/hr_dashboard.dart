import 'package:bonus_tracker_app/core/theme/app_colors.dart';
import 'package:bonus_tracker_app/core/theme/app_text_styles.dart';
import 'package:bonus_tracker_app/core/widgets/note_card.dart';
import 'package:bonus_tracker_app/core/widgets/progress_bar_indicator.dart';
// import 'package:bonus_tracker_app/core/widgets/stat_box.dart';
import 'package:bonus_tracker_app/features/members/cubit/member_cubit.dart';
import 'package:bonus_tracker_app/screens/note_details_screen.dart';
import 'package:bonus_tracker_app/screens/notes_screen.dart';
import 'package:bonus_tracker_app/shared/models/meeting_model.dart';
import 'package:bonus_tracker_app/shared/models/member_model.dart';
import 'package:bonus_tracker_app/shared/models/monthly_stats_model.dart';
import 'package:bonus_tracker_app/shared/models/note_model.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HrDashboard extends StatelessWidget {
  const HrDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    //Trying
    final List<MemberModel> members = [
      MemberModel(
        userId: '1',
        displayName: 'Ahmed Mohamed',
        role: MemberRole.member,
        joinedAt: DateTime(2025, 10, 1),
        stats: MemberStats(
          mohsensCount: 12,
          warningsCount: 1,
          lastUpdatedAt: DateTime.now(),
        ),
        traits: const MemberTraits(
          activeness: 90,
          teamwork: 85,
          flexibility: 88,
          goodAttitude: 95,
          badAttitude: 5,
        ),
      ),

      MemberModel(
        userId: '2',
        displayName: 'Sara Ali',
        role: MemberRole.member,
        joinedAt: DateTime(2025, 11, 15),
        stats: MemberStats(
          mohsensCount: 8,
          warningsCount: 0,
          lastUpdatedAt: DateTime.now(),
        ),
        traits: const MemberTraits(
          activeness: 75,
          teamwork: 92,
          flexibility: 80,
          goodAttitude: 90,
          badAttitude: 3,
        ),
      ),

      MemberModel(
        userId: '3',
        displayName: 'Youssef Khaled',
        role: MemberRole.member,
        joinedAt: DateTime(2026, 1, 10),
        stats: MemberStats(
          mohsensCount: 5,
          warningsCount: 2,
          lastUpdatedAt: DateTime.now(),
        ),
        traits: const MemberTraits(
          activeness: 60,
          teamwork: 70,
          flexibility: 55,
          goodAttitude: 65,
          badAttitude: 20,
        ),
      ),

      MemberModel(
        userId: '4',
        displayName: 'Mariam Hassan',
        role: MemberRole.member,
        joinedAt: DateTime(2025, 9, 5),
        stats: MemberStats(
          mohsensCount: 15,
          warningsCount: 0,
          lastUpdatedAt: DateTime.now(),
        ),
        traits: const MemberTraits(
          activeness: 95,
          teamwork: 94,
          flexibility: 90,
          goodAttitude: 98,
          badAttitude: 2,
        ),
      ),

      MemberModel(
        userId: '5',
        displayName: 'Omar Mostafa',
        role: MemberRole.member,
        joinedAt: DateTime(2026, 2, 20),
        stats: MemberStats(
          mohsensCount: 3,
          warningsCount: 4,
          lastUpdatedAt: DateTime.now(),
        ),
        traits: const MemberTraits(
          activeness: 45,
          teamwork: 50,
          flexibility: 40,
          goodAttitude: 55,
          badAttitude: 35,
        ),
      ),

      MemberModel(
        userId: '6',
        displayName: 'Nour Tarek',
        role: MemberRole.member,
        joinedAt: DateTime(2025, 8, 1),
        stats: MemberStats(
          mohsensCount: 10,
          warningsCount: 1,
          lastUpdatedAt: DateTime.now(),
        ),
        traits: const MemberTraits(
          activeness: 82,
          teamwork: 79,
          flexibility: 85,
          goodAttitude: 88,
          badAttitude: 8,
        ),
      ),
    ];

    final monthlyStats = [
      MonthlyStatsModel(
        monthKey: '2026-06',
        memberId: '1',
        sessionsAttended: 9,
        sessionsTotal: 10,
        tasksCompleted: 8,
        tasksTotal: 10,
        scorePercent: 90,
        computedAt: DateTime.now(),
      ),

      MonthlyStatsModel(
        monthKey: '2026-06',
        memberId: '2',
        sessionsAttended: 7,
        sessionsTotal: 10,
        tasksCompleted: 7,
        tasksTotal: 10,
        scorePercent: 70,
        computedAt: DateTime.now(),
      ),

      MonthlyStatsModel(
        monthKey: '2026-08',
        memberId: '3',
        sessionsAttended: 5,
        sessionsTotal: 10,
        tasksCompleted: 6,
        tasksTotal: 10,
        scorePercent: 55,
        computedAt: DateTime.now(),
      ),

      MonthlyStatsModel(
        monthKey: '2026-01',
        memberId: '4',
        sessionsAttended: 10,
        sessionsTotal: 10,
        tasksCompleted: 10,
        tasksTotal: 10,
        scorePercent: 98,
        computedAt: DateTime.now(),
      ),

      MonthlyStatsModel(
        monthKey: '2026-09',
        memberId: '1',
        sessionsAttended: 6,
        sessionsTotal: 10,
        tasksCompleted: 5,
        tasksTotal: 10,
        scorePercent: 60,
        computedAt: DateTime.now(),
      ),

      MonthlyStatsModel(
        monthKey: '2026-10',
        memberId: '2',
        sessionsAttended: 10,
        sessionsTotal: 10,
        tasksCompleted: 9,
        tasksTotal: 10,
        scorePercent: 95,
        computedAt: DateTime.now(),
      ),

      MonthlyStatsModel(
        monthKey: '2026-07',
        memberId: '3',
        sessionsAttended: 8,
        sessionsTotal: 10,
        tasksCompleted: 8,
        tasksTotal: 10,
        scorePercent: 80,
        computedAt: DateTime.now(),
      ),
    ];
    //=====================================================

    final cubit = MemberCubit.get(context);
    List<MemberModel> fiteredMembers = [];
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: Padding(
            padding: const EdgeInsets.only(left: 12.5, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Text('Notes', style: AppTextStyles.sectionHeader),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotesScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.textPrimary.withAlpha(90),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return SizedBox(
                        width: 200,
                        child: NoteCard(
                          content: note.content,
                          date: '',
                          title: note.title,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NoteDetailsScreen(note: notes[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    itemCount: notes.length,
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Text(
                      'Sesions & Events',
                      style: AppTextStyles.sectionHeader,
                    ),
                    IconButton(
                      onPressed: () {
                        //الفيل في المنديل
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => NotesScreen()),
                        // );
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.textPrimary.withAlpha(90),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final meeting = meetings[index];

                      return SizedBox(
                        width: 200,
                        child: NoteCard(
                          content: meeting.description,
                          date: '',
                          title: meeting.title,
                          onTap: () {
                            //الفيل في المنديل
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         NoteDetailsScreen(note: notes[index]),
                            //   ),
                            // );
                          },
                        ),
                      );
                    },
                    itemCount: meetings.length,
                  ),
                ),
                Row(
                  spacing: 20,
                  children: [
                    Text('Memebers', style: AppTextStyles.sectionHeader),
                    SizedBox(width: 140),
                    Text('month', style: AppTextStyles.statLabel),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: AppColors.borderLight,
                          focusColor: AppColors.border,
                          iconEnabledColor: AppColors.darkSurfaceVariant,
                          iconDisabledColor: AppColors.secondaryDark,
                          borderRadius: BorderRadius.circular(12),
                          style: AppTextStyles.bodyBold,
                          alignment: AlignmentGeometry.center,
                          value: cubit.selectedMonth,

                          items: MemberCubit.months.map((month) {
                            return DropdownMenuItem<String>(
                              value: month,
                              child: Text(month),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              context.read<MemberCubit>().selectMonth(value);
                              fiteredMembers = cubit.filter(
                                members,
                                monthlyStats,
                                value,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  // elevation: 5,
                  child: ListView.builder(
                    padding: EdgeInsets.only(right: 20),
                    // scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final member = fiteredMembers[index];

                      return SizedBox(
                        width: 200,
                        child: ListTile(
                          // onLongPress:(){}, ---> for deletion (firing)
                          onTap: () {},
                          leading: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.textPrimary,
                            child: Icon(
                              Icons.person,
                              color: AppColors.primaryLight,
                              size: 35,
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Text(
                                member.displayName,
                                style: AppTextStyles.heading2,
                              ),
                              ProgressBarIndicator(
                                progress:
                                    monthlyStats[index].scorePercent
                                        .toDouble() /
                                    100,
                                label:
                                    "${(monthlyStats[index].scorePercent.toDouble())}% this month",
                                height: 5,
                              ),
                              // SizedBox(
                              //   height: 87,
                              //   child: Row(
                              //     spacing: 5,
                              //     children: [
                              //       Expanded(
                              //         // height: 50,
                              //         // width: 70,
                              //         child: StatBox(
                              //           value: '${member.stats.mohsensCount}',
                              //           label: 'Mohsens',
                              //           valueFontSize: 15,
                              //         ),
                              //       ),
                              //       Expanded(
                              //         // height: 50,
                              //         // width: 40,
                              //         child: StatBox(
                              //           value: '${member.stats.warningsCount}',
                              //           label: 'Warnings',
                              //           valueFontSize: 15,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          // trailing: IconButton(
                          //   onPressed: () {
                          //     //الفيل في المنديل
                          //     // Navigator.pop(
                          //     //   context,
                          //     //   MaterialPageRoute(builder: (context) => NotesScreen()),
                          //     // );
                          //   },
                          //   icon: Icon(
                          //     Icons.arrow_forward_ios_rounded,
                          //     color: AppColors.textPrimary.withAlpha(90),
                          //   ),
                          // ),
                        ),
                      );
                    },
                    itemCount: fiteredMembers.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

List<NoteModel> notes = [
  NoteModel(
    id: '',
    ownerId: '',
    type: NoteType.hr,
    title: '1st',
    content: '# Hello!!',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  NoteModel(
    id: '',
    ownerId: '',
    type: NoteType.hr,
    title: '2nd',
    content: '## Hello!!',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  NoteModel(
    id: '',
    ownerId: '',
    type: NoteType.hr,
    title: '3rd',
    content: '### Hello!!',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  NoteModel(
    id: '',
    ownerId: '',
    type: NoteType.hr,
    title: '4th',
    content: '#### Hello!!',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  NoteModel(
    id: '',
    ownerId: '',
    type: NoteType.hr,
    title: '5th',
    content: '** Hello!! **',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  NoteModel(
    id: '',
    ownerId: '',
    type: NoteType.hr,
    title: '6th',
    content: '- [ ] Hello!!',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  NoteModel(
    id: '',
    ownerId: '',
    type: NoteType.hr,
    title: '7th',
    content: '- [x] Hello!!',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  NoteModel(
    id: '',
    ownerId: '',
    type: NoteType.hr,
    title: '8th',
    content: 'Hello!!',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];
List<MeetingModel> meetings = [
  MeetingModel(
    id: '',
    description: 'الفيل في المنديل',
    date: DateTime.now(),
    title: '1st',
    createdBy: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  MeetingModel(
    id: '',
    description: '',
    date: DateTime.now(),
    title: '1st',
    createdBy: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  MeetingModel(
    id: '',
    description: '',
    date: DateTime.now(),
    title: '1st',
    createdBy: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  MeetingModel(
    id: '',
    description: '',
    date: DateTime.now(),
    title: '1st',
    createdBy: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  MeetingModel(
    id: '',
    description: 'الفيل في المنديل',
    date: DateTime.now(),
    title: '1st',
    createdBy: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  MeetingModel(
    id: '',
    description: '',
    date: DateTime.now(),
    title: '1st',
    createdBy: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  MeetingModel(
    id: '',
    description: '',
    date: DateTime.now(),
    title: '1st',
    createdBy: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  MeetingModel(
    id: '',
    description: '',
    date: DateTime.now(),
    title: '1st',
    createdBy: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];
