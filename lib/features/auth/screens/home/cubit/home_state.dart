import 'package:bonus_tracker_app/shared/models/committee_model.dart';
import 'package:bonus_tracker_app/shared/models/event_model.dart';
import 'package:bonus_tracker_app/shared/models/member_model.dart';
import 'package:bonus_tracker_app/shared/models/meeting_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CommitteeModel> committees;
  final List<MeetingModel> meetings;
  final List<EventModel> events;
  final Map<String, MemberStats> memberStatsByCommitteeId;
  final int selectedIndex;

  HomeLoaded(
    this.committees,
    this.meetings,
    this.events, {
    this.memberStatsByCommitteeId = const {},
    this.selectedIndex = 0,
  });

  HomeLoaded copyWith({int? selectedIndex}) {
    return HomeLoaded(
      committees,
      meetings,
      events,
      memberStatsByCommitteeId: memberStatsByCommitteeId,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
