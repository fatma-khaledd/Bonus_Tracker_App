import 'package:bonus_tracker_app/core/widgets/app_card.dart';
import 'package:bonus_tracker_app/core/widgets/app_events_card.dart';
import 'package:bonus_tracker_app/core/widgets/app_top_bar.dart';
import 'package:bonus_tracker_app/core/widgets/committee_chip.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadHomeData(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF3E4),

        appBar: AppTopBar(),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeLoaded) {
              final selectedCommittee = state.committees.isEmpty
                  ? null
                  : state.committees[state.selectedIndex];
              final selectedStats = selectedCommittee == null
                  ? null
                  : state.memberStatsByCommitteeId[selectedCommittee.id];
              final filteredMeetings = state.meetings
                  .where(
                    (meeting) =>
                        selectedCommittee != null &&
                        meeting.committeeId == selectedCommittee.id,
                  )
                  .toList();
              final filteredEvents = state.events
                  .where(
                    (event) =>
                        selectedCommittee != null &&
                        event.committeeId == selectedCommittee.id,
                  )
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: selectedCommittee == null
                            ? const SizedBox.shrink()
                            : Center(
                                child: CommitteeChip(
                                  label: selectedCommittee.name,
                                  isSelected: true,
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),

                      //mohsens & warnings
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppCard(
                            color: Color(0xFFF0D2AC),
                            child: Column(
                              children: [
                                Text('Mohsens'),
                                Text('${selectedStats?.mohsensCount ?? 0}'),
                              ],
                            ),
                          ),
                          AppCard(
                            color: Color(0xFFF0D2AC),

                            child: Column(
                              children: [
                                Text('Warnings'),
                                Text('${selectedStats?.warningsCount ?? 0}'),
                              ],
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
                            ? Center(
                                child: const Text(
                                  'No Meetings Yet',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
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
                            ? const Center(
                                child: Text(
                                  'No Meetings Yet',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
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
