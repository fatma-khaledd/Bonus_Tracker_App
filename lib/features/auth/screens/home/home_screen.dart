import 'package:bonus_tracker_app/core/widgets/app_card.dart';
import 'package:bonus_tracker_app/core/widgets/app_events_card.dart';
import 'package:bonus_tracker_app/core/widgets/app_top_bar.dart';
import 'package:bonus_tracker_app/core/widgets/committee_chip.dart';
import 'package:bonus_tracker_app/core/widgets/empty_state_widget.dart';
import 'package:bonus_tracker_app/core/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0; // للتحكم في اللجنة المتاحة حالياً وتحديث الـ UI

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadHomeData(),
      child: Scaffold(
        backgroundColor: const Color(
          0xFFFFF3E4,
        ), // خلفية بيج فاتحة مطابقة للتصميم
        appBar: AppTopBar(),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeLoaded) {
              final selectedCommittee = state.committees[selectedIndex];

              final filteredMeetings = state.meetings
                  .where(
                    (meeting) => meeting.committeeId == selectedCommittee.id,
                  )
                  .toList();

              final filteredEvents = state.events
                  .where((event) => event.committeeId == selectedCommittee.id)
                  .toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //commitee names
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.committees.length,
                        itemBuilder: (context, index) {
                          final committee = state.committees[index];
                          return CommitteeChip(label: committee.name);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    //mohsens & warnings
                    Row(
                      children: const [
                        AppCard(
                          child: Column(
                            children: [Text('Mohsens'), Text('10')],
                          ),
                        ),
                        AppCard(
                          child: Column(
                            children: [Text('Warnings'), Text('0')],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const SectionHeader(title: 'Meetings'),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 110,
                      child: filteredMeetings.isEmpty
                          ? const EmptyStateWidget(message: 'No Meetings Yet')
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredMeetings.length,
                              itemBuilder: (context, index) {
                                final meeting = filteredMeetings[index];
                                return AppEventsCard(
                                  title: meeting.title,
                                  date: meeting.date,
                                );
                              },
                            ),
                    ),
                    // const SizedBox(height: 24),
                    const SectionHeader(title: 'Events'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 110,
                      child: filteredEvents.isEmpty
                          ? const EmptyStateWidget(message: 'No Events Yet')
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredEvents.length,
                              itemBuilder: (context, index) {
                                final event = filteredEvents[index];
                                return AppEventsCard(
                                  title: event.title,
                                  date: event.date,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            }
            if (state is HomeError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No home data available'));
          },
        ),
      ),
    );
  }
}
